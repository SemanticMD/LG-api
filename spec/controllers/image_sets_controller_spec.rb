require 'rails_helper'
RSpec.describe ImageSetsController, :type => :controller do

  describe '#create' do
    let!(:user) { Fabricate(:user) }
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
  end
end
