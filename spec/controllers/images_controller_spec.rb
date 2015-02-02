require 'rails_helper'

RSpec.describe ImagesController, :type => :controller do

  describe '#show' do
    let!(:image) { Fabricate(:image) }
    let(:request) { ->{ get :show, id: image.id } }
    before { request.call }
    subject { response }
    it { expect(subject).to serialize_to(ImageSerializer, image) }
  end

  describe '#create' do
    let(:image_set) { Fabricate(:image_set) }
    let(:params) {
      {
        image: {
          url: 'lionguardians.org',
          image_type: 'whisker',
          image_set_id: image_set.id
        }
      }
    }

    let(:request) { ->{ post :create, params } }

    it {
      expect { request.call }.to change { Image.count }.by(1)
    }
  end

  describe '#update' do
    let!(:image) { Fabricate(:public_image) }
    let(:new_url) { 'isaacezer.com' }
    let(:params) {
      {
        url: new_url,
        is_public: false
      }
    }

    let(:request) { ->{ put :update, id: image.id, image: params } }

    it {
      expect { request.call }.to change{ image.reload.url }.to(new_url)
    }

    it {
      expect { request.call }.to change{ image.reload.is_public }.
                                  from(true).to(false)
    }
  end
end
