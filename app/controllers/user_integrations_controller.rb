class UserIntegrationsController < ApplicationController
  def index
    @user_integrations = current_user.user_integrations
  end

  def ai_connect
    @chat_models = AiModel.where(category: 'chat').pluck(:id, :name).map { |key, label| [label, key] }
    @embedding_models = AiModel.where(category: 'embedding').pluck(:id, :name).map { |key, label| [label, key] }
    @user_integration = current_user.user_integrations.find(params[:id])
  end

  def update_ai
    @user_integration = current_user.user_integrations.find(params[:id])
    @user_integration.connected_at = Time.current

    if @user_integration.update(user_integration_params)
      flash[:success] = 'AI Integration updated successfully.'
    else
      flash.now[:alert] = @user_integration.errors.full_messages.to_sentence
    end
  end

  def disconnect
    @user_integration = current_user.user_integrations.find(params[:id])
    @user_integration.disconnect!
    flash.now[:success] = 'Integration disconnected successfully.'
  end

  private

  def user_integration_params
    params.expect(user_integration: %i[active_chat_id active_embedding_id access_token])
  end
end
