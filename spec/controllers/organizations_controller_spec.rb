require 'rails_helper'
RSpec.describe OrganizationsController, :type => :controller do
  let(:resource) { Fabricate(:user) }
  before { sign_in resource }
  subject { request.call }

  describe '#index' do
    let!(:org) { resource.organization }
    let(:request) { ->{ get :index } }

    it_behaves_like "an authenticated controller"
    it { expect(subject).to serialize_to(OrganizationsSerializer, [org]) }
  end
end
