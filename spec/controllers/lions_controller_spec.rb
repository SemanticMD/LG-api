require 'rails_helper'

RSpec.describe LionsController, :type => :controller do
  subject { request.call }

  describe '#show' do
    let(:lion) { Fabricate :lion }
    let(:request) { ->{ get :show, id: lion.id } }

    it { expect(subject).to serialize_to(LionSerializer, lion) }
  end

  describe '#index' do
    let(:lion1) { Fabricate(:male_lion).tap { |l|
                    l.primary_image_set.update(date_of_birth: 24.years.ago)
                  }
    }

    let(:lion2) { Fabricate(:female_lion).tap { |l|
                    l.primary_image_set.update(date_of_birth: 29.years.ago)
                  }
    }

    let!(:lions) { [lion1, lion2] }
    let(:request) { ->{ get :index, params } }

    context 'no params' do
      let(:params) { {} }
      it { expect(subject).to serialize_to(LionsSerializer, lions) }
    end

    describe 'search by age' do
      let(:params) { { dob_range_start: 25.years.ago, dob_range_end: 23.years.ago } }

      it { expect(subject).to serialize_to(LionsSerializer, [lion1]) }
    end

    describe 'search by gender' do
      let(:params) { { gender: 'female' } }

      it { expect(subject).to serialize_to(LionsSerializer, [lion2]) }
    end
  end

  describe '#create' do
    let(:resource) { Fabricate(:user) }
    before { sign_in resource }

    let(:name) { 'isaac' }
    let(:image_set) { Fabricate :image_set }
    let(:params) {
      {
        lion: {
          primary_image_set_id: image_set.id,
          name: name
        }
      }
    }
    let(:request) { ->{ post :create, params } }

    it_behaves_like "an authenticated controller"
    it { expect { subject }.to change { Lion.count }.by(1) }
    it { expect(subject).to serialize_to(LionSerializer, Lion.all.last) }

    describe 'bad image set id' do
      let(:params) { { lion: {name: 'isaac'} } }
      it {
        expect(subject).to error_invalid_resource_with(
                             { primary_image_set: ["for lion creation not found"] })
      }
    end

    describe 'bad image set' do
      before { image_set.update(lion: Fabricate(:lion)) }

      it {
        expect(subject).to error_invalid_resource_with(
                             { primary_image_set: ["already associated with another lion"] })
      }
    end

    describe 'missing name' do
      let(:params) { { lion: {primary_image_set_id: image_set.id} } }
      it {
        expect(subject).to error_invalid_resource_with(
                             { name: ["can't be blank"] })
      }
    end
  end

  describe '#update' do
    let(:resource) { Fabricate(:user) }
    before { sign_in resource }

    let(:user) { resource }
    let(:lion) { Fabricate(:lion, name: 'Simba', organization: user.organization) }
    let!(:primary_image_set) { lion.primary_image_set }
    let(:new_image_set) { Fabricate(:image_set_with_1_image, lion: lion, organization: user.organization, uploading_organization: user.organization, uploading_user: user) }

    let(:request) { -> { put :update, id: lion.id, lion: params } }

    let(:params) {
      {
        name: 'Isaac',
        primary_image_set_id: new_image_set.id }
    }

    it_behaves_like "an authenticated controller"

    it {
      expect {subject}.to change {lion.reload.primary_image_set}.from(primary_image_set).to(new_image_set)
    }

    it {
      expect {subject}.to change {lion.reload.name}.from('Simba').to('Isaac')
    }

    describe 'user does not own image set' do
      let(:user) { Fabricate :user }
      it { expect(subject).to error_deny_access }
    end

    describe 'not found' do
      let(:request) { ->{ put :update, id: 'bad id' } }
      it { expect(subject).to error_not_found_with('lion not found') }
    end
  end

  describe '#destroy' do
    let(:resource) { Fabricate(:user) }
    before { sign_in resource }

    let(:user) { resource }
    let!(:lion) { Fabricate(:lion, organization: user.organization) }
    let(:image_set) { lion.primary_image_set }
    let(:request) { ->{ delete :destroy, id: lion.id } }

    before { image_set.update(is_verified: true) }

    it_behaves_like "an authenticated controller"
    it { expect { subject }.to change { Lion.count }.by(-1) }
    it { expect { subject }.to change {image_set.reload.lion_id}.to(nil) }
    it { expect { subject }.to change {image_set.reload.is_verified}.from(true).to(false) }

    describe 'not found' do
      let(:request) { ->{ delete :destroy, id: 'bad id' } }
      it { expect(subject).to error_not_found_with('lion not found') }
    end

    describe 'user does not own lion' do
      let!(:lion) { Fabricate :lion }
      let(:request) { ->{ delete :destroy, id: lion.id } }
      it { expect(subject).to error_deny_access }
    end
  end
end
