require 'rails_helper'

RSpec.describe CodeReviewsController, type: :controller do
  describe 'GET #index' do
    context 'when user is not authenticated' do
      include_examples 'redirects to login', :get, :index
    end

    context 'when user is logged in' do
      include_context 'with authenticated user'

      context 'when not in development env' do
        it 'redirects to root' do
          get :index
          expect(response).to redirect_to(root_path)
        end
      end

      context 'when in development env' do
        before { allow(Rails.env).to receive(:development?).and_return(true) }

        it 'returns a successful response' do
          get :index
          expect(response).to have_http_status(:ok)
        end
      end
    end
  end

  describe 'GET #show' do
    context 'when user is not authenticated' do
      include_examples 'redirects to login', :get, :show, { filename: 'somefile' }
    end

    context 'when user is logged in' do
      include_context 'with authenticated user'
    end
  end
end
