require 'rails_helper'
RSpec.describe CvRequestsController, :type => :controller do
  let(:resource) { Fabricate :user }
  before { sign_in resource }
  subject { request.call }

  describe '#show' do
    let!(:cv_request) { Fabricate(:cv_request) }
    let(:request) { ->{ get :show, id: cv_request.id } }

    it_behaves_like "an authenticated controller"
    it { expect(subject).to serialize_to(CvRequestSerializer, cv_request) }
  end

  describe '#create' do
    let(:image_set) { Fabricate :image_set, organization: resource.organization }
    let(:params) { {
      image_set_id: image_set.id,
    } }
    let(:request) { ->{post :create, cv_request: params } }

    it_behaves_like "an authenticated controller"
    it { expect { subject }.to change { CvRequest.count }.by(1) }

    context 'created object' do
      before { request.call }
      subject { CvRequest.last }
      it {
        expect(subject.image_set).to eq image_set
        expect(subject.uploading_organization).to eq image_set.organization
        expect(subject.status).to eq 'created'
      }
    end

    context 'duplicate image set' do
      let!(:cv_request) { Fabricate(:cv_request, image_set: image_set) }
      it {
        expect(subject).to error_invalid_resource_with(
                             {
                               image_set: ['has already been taken']
                             })
      }
    end

    describe 'not found' do
      let(:params) {
        {
          image_set_id: 'bad id'
        }
      }

      it { expect(subject).to error_not_found_with('image set not found') }
    end
  end
end
