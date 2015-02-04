require 'rails_helper'

RSpec.describe LionsController, :type => :controller do
  describe '#show' do
    let(:lion) { Fabricate :lion }
    let(:request) { ->{ get :show, id: lion.id } }
    before { request.call }
    subject { response }
    it { expect(subject).to serialize_to(LionSerializer, lion) }
  end

  describe '#index' do
    let!(:lion) { Fabricate :lion }
    let(:request) { ->{ get :index, params } }
    let(:params) { {} }
    before { request.call }
    subject { response }
    it { expect(subject).to serialize_to(LionsSerializer, [lion]) }

    describe 'search by age' do
      let!(:lion) { Fabricate(:lion, age: '24')}
      let!(:lion_2) { Fabricate(:lion, age: '25')}
      let(:params) { { age: '24' } }
      it { expect(subject).to serialize_to(LionsSerializer, [lion]) }
    end

    describe 'search by gender' do
      let!(:lion) { Fabricate(:lion, gender: 'male') }
      let!(:lion_2) { Fabricate(:lion,  gender: 'female')}
      let(:params) { { gender: 'male' } }
      it { expect(subject).to serialize_to(LionsSerializer, [lion]) }
    end
  end
end
