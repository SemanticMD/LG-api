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

    describe 'no lion' do
      let(:cv_result) { Fabricate.build(:cv_result, lion: nil) }
      it { should_not be_valid }
    end
  end
end
