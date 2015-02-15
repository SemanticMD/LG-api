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
    it { expect(lion.date_of_birth).to eq image_set.date_of_birth }
    it { expect(lion.gender).to eq image_set.gender }
    it { expect(lion.organization).to eq image_set.organization }
    it { expect(image_set.reload.lion).to eq lion }
  end

  describe 'set DOB' do
    let(:birthdate) { 26.years.ago }
    let(:lion) { Fabricate :lion, date_of_birth: birthdate }

    it { expect(lion).to be_valid }
    it { expect(lion.date_of_birth).to eq birthdate }
  end
end
