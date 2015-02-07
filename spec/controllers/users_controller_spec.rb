require 'rails_helper'
RSpec.describe UsersController, :type => :controller do
  describe '#show' do
    let!(:user) { Fabricate :user }
    let(:request) { ->{ get :show, {id: user.id} } }
    before { request.call }
    subject { response }
    it { expect(subject).to serialize_to(UserSerializer, user) }
  end
end
