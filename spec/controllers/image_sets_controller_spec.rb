require 'rails_helper'
RSpec.describe ImageSetsController, :type => :controller do

  describe '#create' do
    let(:user) { Fabricate(:user) }
    let(:params) {
      {
        image_set: {
          latitude: '-9.0000',
          longitude: '37.4000',
          user_id: user.id
        }
      }
    }

    let(:request) { ->{ post :create, params } }

    it {
      expect { request.call }.to change { ImageSet.count }.by(1)
    }

    describe 'with nested images' do
      let(:params) {
        {
          image_set: {
            latitude: '-9.0000',
            longitude: '37.4000',
            user_id: user.id,
            images: [
              Fabricate.attributes_for(:new_image_wo_image_set),
              Fabricate.attributes_for(:new_image_wo_image_set)
            ]
          }
        }
      }

      it {
        expect { request.call }.to change { ImageSet.count }.by(1)
      }

      it {
        expect { request.call }.to change { Image.count }.by(2)
      }
    end
  end

  describe '#update' do
    let(:image_set) { Fabricate :image_set_with_images }
    let(:main_image) { image_set.images.first }
    let(:request) { -> { put :update, id: image_set.id, image_set: params } }
    let(:params) {
      {
        main_image_id: main_image.id,
        user_id: image_set.uploading_user.id
      }
    }

    it {
      expect { request.call }.to change { image_set.reload.main_image }.
                                  from(nil).to(main_image)
    }
  end
end
