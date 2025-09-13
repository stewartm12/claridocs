RSpec.shared_context 'with authenticated user' do
  let(:user) { create(:user) }
  let(:session) { create(:session, user: user) }

  before do
    allow(controller).to receive(:resume_session).and_return(session)
    allow(Current).to receive(:user).and_return(user)
    allow(Current).to receive(:session).and_return(session)
  end
end
