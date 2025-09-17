module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :require_authentication
    helper_method :authenticated?, :current_session, :current_user
  end

  class_methods do
    def allow_unauthenticated_access(**options)
      skip_before_action :require_authentication, **options
    end
  end

  private

  def authenticated?
    resume_session
  end

  def require_authentication
    resume_session || request_authentication
  end

  def current_session
    Current.session
  end

  def current_user
    Current.session&.user
  end

  def resume_session
    Current.session ||= find_session_by_cookie || find_session_by_remember_token

    return false unless Current.session

    extend_session_if_needed
    cleanup_remember_token_if_expired
    true
  end

  def find_session_by_cookie
    return nil unless cookies.signed[:session_id]

    session = Session.find_by(id: cookies.signed[:session_id])
    session unless session&.expired?
  end

  def find_session_by_remember_token
    return nil unless cookies.signed[:remember_token]

    session = find_valid_remember_token_session
    return nil unless session

    rotate_remember_token!(session)
    start_new_session_for(session.user, remember_me: false, parent_session: session)
  end

  def find_valid_remember_token_session
    session = Session.find_by(remember_token: cookies.signed[:remember_token])
    return nil unless session
    return nil if session.remember_token_expired?

    session
  end

  def rotate_remember_token!(session)
    session.extend_remember_token!

    set_cookie(:remember_token,
               value: session.remember_token,
               expires: session.remember_token_expires_at)
  end

  def extend_session_if_needed
    return unless Current.session
    return unless Current.session.expires_at < 30.minutes.from_now

    Current.session.extend_expiration!
    set_cookie(:session_id, value: Current.session.id, expires: Current.session.expires_at)
  end

  def cleanup_remember_token_if_expired
    return unless Current.session&.remember_token_expired?

    Current.session.update!(remember_token: nil, remember_token_expires_at: nil)
    cookies.delete(:remember_token)
  end

  def request_authentication
    session[:return_to_after_authenticating] = request.url
    redirect_to new_session_path
  end

  def after_authentication_url
    session.delete(:return_to_after_authenticating) || dashboard_path
  end

  def start_new_session_for(user, remember_me: false, parent_session: nil)
    cleanup_expired_sessions(user, exclude: parent_session)

    if parent_session
      reactivate_parent_session(parent_session)
    else
      create_new_session(user, remember_me: remember_me)
    end
  end

  def cleanup_expired_sessions(user, exclude: nil)
    expired_scope = user.sessions.expired
    expired_scope = expired_scope.where.not(id: exclude.id) if exclude
    expired_scope.destroy_all
  end

  def reactivate_parent_session(session)
    session.extend_expiration!
    Current.session = session

    set_cookie(:session_id, value: session.id, expires: session.expires_at)
    session
  end

  def create_new_session(user, remember_me: false)
    user.sessions.create!(user_agent: request.user_agent, ip_address: request.remote_ip).tap do |new_session|
      Current.session = new_session

      set_cookie(:session_id, value: new_session.id, expires: Session::DEFAULT_SESSION_DURATION.from_now)
      setup_remember_me_cookie(new_session) if remember_me
    end
  end

  def setup_remember_me_cookie(session)
    session.extend_remember_token!

    set_cookie(:remember_token, value: session.remember_token, expires: Session::REMEMBER_ME_DURATION.from_now)
  end

  def set_cookie(name, value:, expires:)
    cookies.signed[name] = {
      value: value,
      expires: expires,
      httponly: true,
      secure: Rails.env.production?,
      same_site: :lax
    }
  end

  def terminate_session
    Current.session&.destroy!
    Current.session = nil
    cookies.delete(:session_id)
    cookies.delete(:remember_token)
  end
end
