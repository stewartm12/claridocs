require 'rails_helper'

RSpec.describe DashboardsController, type: :controller do
  describe 'GET#show' do
    context 'when user is not authenticated' do
      include_examples 'redirects to login', :get, :show
    end

    context 'when user is authenticated' do
      include_context 'with authenticated user'

      it 'returns a successful response' do
        get :show

        expect(response).to have_http_status(:ok)
      end
    end
  end
end
