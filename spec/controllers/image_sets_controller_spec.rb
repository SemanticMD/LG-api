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

  describe '#index' do
    let(:request) { -> { get :index, params } }
    let(:params) { {} }
    let(:user) { resource }
    let!(:image_set) { Fabricate(:image_set, gender: 'male',
                                 organization: user.organization) }
    let!(:image_set_2) { Fabricate(:image_set, gender: 'female') }

    it_behaves_like "an authenticated controller"

    context 'no organization id returns all results' do
      it { expect(subject).to serialize_to(ImageSetsSerializer,
                                           [image_set, image_set_2]) }
    end

    context 'wrong organization id returns nothing' do
      let(:params) { { organization_id: 'bad_id' } }
      it { expect(subject).to serialize_to(ImageSetsSerializer, []) }
    end

    context 'search by organization id' do
      let(:params) { { organization_id: user.organization.id } }
      it { expect(subject).to serialize_to(ImageSetsSerializer, [image_set]) }
    end

    context 'search by gender' do
      let(:params) { { gender: 'female' } }
      it { expect(subject).to serialize_to(ImageSetsSerializer, [image_set_2]) }
    end

    context 'search by name' do
      let(:lion) { Fabricate :lion }
      let(:image_set_3) { lion.primary_image_set }
      let(:params) { { name: lion.name } }
      it { expect(subject).to serialize_to(ImageSetsSerializer, [image_set_3]) }
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
    let(:user) { resource }
    let(:image_set) { Fabricate :image_set_with_images, main_image: nil, organization: user.organization }
    let(:main_image) { image_set.images.first.tap { |image|
                         image.update(is_public: true) } }
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

    describe 'not found' do
      let(:request) { ->{ put :update, id: 'bad id' } }
      it { expect(subject).to error_not_found_with('image set not found') }
    end

    describe 'user does not own image set' do
      let(:user) { Fabricate :user }
      it { expect(subject).to error_deny_access }
    end

    describe 'invalid main image' do
      let(:main_image) { image_set.images.first }
      it {
        expect(subject).to error_invalid_resource_with(
                             {
                               main_image: ['must be publicly accessible']
                             })
      }
    end

    describe 'duplicate lion id' do
      before { image_set.update(lion: Fabricate(:lion)) }
      let(:new_lion) { Fabricate :lion }
      let(:params) {
        { lion_id: new_lion.id }
      }

      it {
        expect(subject).to error_invalid_resource_with(
                             {
                               lion: ["#{image_set.id} already associated with a different lion #{image_set.lion.name}"]
                             })
      }
    end

    describe 'bad lion id' do
      let(:params) {
        { lion_id: 'bad id' }
      }

      it {
        expect(subject).to error_invalid_resource_with(
                             {
                               lion: ["can't be blank"]
                             })
      }
    end
  end

  describe '#destroy' do
    let(:user) { resource }
    let!(:image_set) { Fabricate :image_set_with_images, organization: user.organization }
    let(:request) { -> { delete :destroy, id: image_set.id } }

    it_behaves_like "an authenticated controller"
    it { expect { subject }.to change { ImageSet.count }.by(-1) }

    it { expect { subject }.to change { Image.where(is_deleted: true).count }.by(5) }

    describe 'not found' do
      let(:request) { ->{ delete :destroy, id: 'bad id' } }
      it { expect(subject).to error_not_found_with('image set not found') }
    end

    describe 'user does not own image set' do
      let!(:image_set) { Fabricate :image_set }
      let(:request) { ->{ delete :destroy, id: image_set.id } }
      it { expect(subject).to error_deny_access }
    end
  end
end
