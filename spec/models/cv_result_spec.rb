require 'rails_helper'

RSpec.describe CvResult, :type => :model do
  subject { cv_result }

  describe 'validations' do
    let(:cv_result) { Fabricate :cv_result }
    it { should be_valid }

    describe 'bad probability' do
      let(:cv_result) { Fabricate.build(:cv_result, match_probability: -1) }
      it { should_not be_valid }
    end

    describe 'no cv_request' do
      let(:cv_result) { Fabricate.build(:cv_result, cv_request: nil) }
      it { should_not be_valid }
    end

    describe 'no image' do
      let(:cv_result) { Fabricate.build(:cv_result, image: nil) }
      it { should_not be_valid }
    end
  end

  describe 'can fetch associated lion' do
    let(:lion) { Fabricate :lion }
    let(:cv_result) { Fabricate :cv_result, image: lion.primary_image_set.main_image }

    it { expect(cv_result.lion).to eq lion }
  end
end
