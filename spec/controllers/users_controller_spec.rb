require 'rails_helper'
RSpec.describe UsersController, :type => :controller do
  let(:resource) { Fabricate(:user) }
  before { sign_in resource }
  subject { request.call }

  describe '#show' do
    let!(:user) { Fabricate :user }
    let(:request) { ->{ get :show, {id: user.id} } }

    it_behaves_like "an authenticated controller"
    it { expect(subject).to serialize_to(UserSerializer, user) }
  end
end
