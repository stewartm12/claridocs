require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe 'GET #new' do
    context 'when user is authenticated' do
      include_context 'with authenticated user'

      it 'redirects to the dashboard page' do
        post :create, params: {}

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(dashboard_path)
      end
    end

    context 'when user is not authenticated' do
      it 'returns a successful response' do
        get :new

        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'POST #create' do
    context 'when user is authenticated' do
      include_context 'with authenticated user'

      it 'redirects to the dashboard page' do
        post :create, params: {}

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(dashboard_path)
      end
    end

    context 'when user is not authenticated' do
      let(:user) { create(:user, email: 'test@example.com', password: 'Password123!') }
      let(:params) do
        {
          email: user.email,
          password: 'Password123!'
        }
      end

      context 'with valid credentials' do
        before { post :create, params: params }

        it 'redirects to the dashboard' do
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to(dashboard_path)
        end

        it 'creates a new session' do
          expect(Session.count).to eq(1)
          expect(Session.last.user).to eq(user)
        end
      end

      context 'with invalid credentials' do
        it 'redirects to login page' do
          post :create, params: { email: '', password: '' }, as: :turbo_stream

          expect(flash[:alert]).to eq('Email or password is incorrect.')
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    include_context 'with authenticated user'

    it 'destroys the session' do
      delete :destroy

      expect(Session.count).to eq(0)
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(new_session_path)
    end
  end
end
