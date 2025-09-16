require 'rails_helper'

RSpec.describe RegistrationsController, type: :controller do
  describe 'GET#new' do
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

  describe 'POST#create' do
    context 'when user is authenticated' do
      include_context 'with authenticated user'

      it 'redirects to the dashboard page' do
        post :create, params: {}

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(dashboard_path)
      end
    end

    context 'when user is not authenticated' do
      let(:params) do
        { user: {
          name: 'John Doe',
          email: 'john@gmail.com',
          password: 'Password123!',
          password_confirmation: 'Password123!'
        } }
      end

      it 'builds a new user with permitted parameters' do
        post :create, params: params

        expect(controller.instance_variable_get(:@user).name).to eq('John Doe')
        expect(controller.instance_variable_get(:@user).email).to eq('john@gmail.com')
      end

      context 'with valid parameters' do
        it 'creates a new user' do
          expect {
            post :create, params: params
          }.to change { User.count }.by(1)

          expect(response).to have_http_status(:found)
          expect(response).to redirect_to(new_session_path)
          expect(flash[:success]).to include('Account created successfully. Please login.')
        end

        context 'with invalid parameters' do
          before { params[:user][:email] = nil }

          it 'does not create a new user' do
            expect {
              post :create, params: params, as: :turbo_stream
            }.not_to change { User.count }

            expect(flash[:alert]).to include("Email can't be blank\n Email is invalid")
          end
        end
      end
    end
  end
end
