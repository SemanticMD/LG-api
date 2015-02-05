require 'rails_helper'
RSpec.describe OrganizationsController, :type => :controller do
  describe '#index' do
    let!(:org) { Fabricate :organization }
    let(:request) { ->{ get :index } }
    before { request.call }
    subject { response }
    it { expect(subject).to serialize_to(OrganizationsSerializer, [org]) }
  end
end
