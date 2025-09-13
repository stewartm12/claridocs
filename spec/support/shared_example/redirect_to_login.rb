RSpec.shared_examples 'redirects to login' do |http_method, action, params|
  it 'redirects to the login page' do
    public_send(http_method, action, params: params)
    expect(response).to redirect_to(new_session_path)
  end
end
