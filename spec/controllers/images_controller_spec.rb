require 'rails_helper'

RSpec.describe ImagesController, :type => :controller do
  let(:resource) { Fabricate :user }
  before { sign_in resource }
  subject { request.call }

  describe '#show' do
    let!(:image) { Fabricate(:image) }
    let(:request) { ->{ get :show, id: image.id } }

    it_behaves_like "an authenticated controller"
    it { expect(subject).to serialize_to(ImageSerializer, image) }
  end

  describe '#create' do
    let(:image_set) { Fabricate(:image_set) }
    let(:params) { {
      image: {
        url: 'lionguardians.org',
        image_type: 'whisker',
        image_set_id: image_set.id
      }
    } }
    let(:request) { ->{ post :create, params } }

    it_behaves_like "an authenticated controller"
    it { expect { subject }.to change { Image.count }.by(1) }
  end

  describe '#update' do
    let!(:image) { Fabricate(:public_image) }
    let(:new_url) { 'isaacezer.com' }
    let(:params) { {
      url: new_url,
      is_public: false
    } }
    let(:request) { ->{ put :update, id: image.id, image: params } }

    it_behaves_like "an authenticated controller"
    it { expect { subject }.to change{ image.reload.url }.to(new_url) }
    it {
      expect { subject }.to \
        change{ image.reload.is_public }.from(true).to(false)
    }
  end
end
