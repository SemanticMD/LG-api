require 'rails_helper'

RSpec.describe CvRequest, :type => :model do
  subject { cv_request }

  describe 'validations' do
    let(:cv_request) { Fabricate :cv_request }
    it { should be_valid }

    describe 'bad status' do
      let(:cv_request) { Fabricate.build(:cv_request, status: 'bad') }
      it { should_not be_valid }
    end

    describe 'no image_set' do
      let(:cv_request) { Fabricate.build(:cv_request, image_set: nil,
                                         uploading_organization: Fabricate(:organization)) }
      it { should_not be_valid }
    end

    describe 'no uploading_organization' do
      let(:cv_request) { Fabricate.build(:cv_request, uploading_organization: nil) }
      it { should_not be_valid }
    end
end
end
