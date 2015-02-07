require 'rails_helper'
RSpec.describe ImageSetsController, :type => :controller do
  let(:resource) { Fabricate :user }
  before { sign_in resource }
  subject { request.call }

  describe '#show' do
    let!(:image_set) { Fabricate(:image_set) }
    let(:request) { ->{ get :show, id: image_set.id } }

    it_behaves_like "an authenticated controller"
    it { expect(subject).to serialize_to(ImageSetSerializer, image_set) }

    describe 'not found' do
      let(:request) { ->{ get :show, id: 'bad id' } }
      it { expect(subject).to error_not_found_with('image set not found') }
    end
  end

  describe '#create' do
    let(:user) { Fabricate(:user) }
    let(:params) { {
      image_set: {
        latitude: '-9.0000',
        longitude: '37.4000',
        user_id: user.id
      }
    } }
    let(:request) { ->{ post :create, params } }

    it_behaves_like "an authenticated controller"
    it { expect { subject }.to change { ImageSet.count }.by(1) }

    describe 'with nested images' do
      let(:params) { {
        image_set: {
          latitude: '-9.0000',
          longitude: '37.4000',
          user_id: user.id,
          images: [
            Fabricate.attributes_for(:new_image_wo_image_set),
            Fabricate.attributes_for(:new_image_wo_image_set)
          ]
        }
      } }

      it { expect { subject }.to change { ImageSet.count }.by(1) }
      it { expect { subject }.to change { Image.count }.by(2) }
    end
  end

  describe '#update' do
    let(:image_set) { Fabricate :image_set_with_images, main_image: nil }
    let(:main_image) { image_set.images.first }
    let(:request) { -> { put :update, id: image_set.id, image_set: params } }
    let(:params) {
      {
        main_image_id: main_image.id,
        user_id: image_set.uploading_user.id
      }
    }

    it {
      expect { subject }.to \
        change { image_set.reload.main_image }.from(nil).to(main_image)
    }
  end
end
