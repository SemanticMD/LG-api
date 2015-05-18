require 'rails_helper'

RSpec.describe Lion, :type => :model do
  describe 'validations' do
    subject { Fabricate :lion }
    it { should be_valid }

    describe 'not valid is primary image set not in image sets' do
      subject { Fabricate.build(:lion, primary_image_set: Fabricate(:image_set)) }
      it { should_not be_valid }
    end
  end

  describe 'create from image set' do
    let(:image_set) { Fabricate :image_set }
    let(:name) { 'isaac' }
    let!(:lion) { Lion.create_from_image_set(image_set, name) }

    it { expect(lion).to be_valid }
    it { expect(lion.name).to eq name }
    it { expect(lion.organization).to eq image_set.organization }
    it { expect(image_set.reload.lion).to eq lion }
  end

  describe 'search' do
    subject { Lion.search(params) }

    context 'by name' do
      let!(:lion1) { Fabricate :lion }
      let!(:lion2) { Fabricate :lion }
      let(:name) { lion1.name }

      let(:params) { {name: name} }

      it {
        expect(subject).to eq([lion1])
      }
    end

    context 'by gender' do
      let!(:male_lion) { Fabricate :lion }
      let!(:female_lion) { Fabricate :female_lion }

      let(:params) { {gender: 'female'} }

      it {
        expect(subject).to eq([female_lion])
      }
    end
  end
end
