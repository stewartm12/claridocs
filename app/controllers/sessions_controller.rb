class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: 'Try again later.' }

  before_action :redirect_signed_in_user, only: %i[new create]

  def new; end

  def create
    if user = User.authenticate_by(params.permit(:email, :password))
      remember_me = params[:remember_me] == '1'
      start_new_session_for(user, remember_me: remember_me)

      redirect_to after_authentication_url
    else
      flash.now[:alert] = 'Email or password is incorrect.' unless user
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path, success: 'Successfully Logged Out.'
  end
end
