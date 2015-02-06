require 'rails_helper'
RSpec.describe CvRequestsController, :type => :controller do

  describe '#show' do
    let!(:cv_request) { Fabricate(:cv_request) }
    let(:request) { ->{ get :show, id: cv_request.id } }
    before { request.call }
    subject { response }
    it { expect(subject).to serialize_to(CvRequestSerializer, cv_request) }
  end

  describe 'create' do
    let(:image_set) { Fabricate :image_set }
    let(:params) {
      {
        image_set_id: image_set.id,
        uploading_organization_id: image_set.uploading_organization.id
      }
    }
    let(:request) { ->{post :create, cv_request: params } }

    it {
      expect { request.call }.to change { CvRequest.count }.by(1)
    }

    context 'created object' do
      before { request.call }
      subject { CvRequest.last }
      it {
        subject.image_set.should eq image_set
        subject.uploading_organization.should eq image_set.uploading_organization
        subject.status.should eq 'created'
      }
    end
  end
end