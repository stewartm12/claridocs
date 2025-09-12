class RegistrationsController < ApplicationController
  allow_unauthenticated_access

  before_action :redirect_signed_in_user

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to new_session_path, success: 'Account created successfully. Please login.'
    else
      flash.now[:alert] = @user.errors.full_messages.join("\n ")
    end
  end

  private

  def user_params
    params.expect(user: %i[name email password password_confirmation])
  end
end
