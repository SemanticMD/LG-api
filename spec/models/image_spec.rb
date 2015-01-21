require 'rails_helper'

RSpec.describe Image, :type => :model do
  subject { image }

  describe 'validations' do
    let(:image) { Fabricate(:image) }
    it { should be_valid }

    context 'no url' do
      let(:image) { Fabricate.build(:image, url: nil) }
      it { should_not be_valid }
    end
  end

  describe 'creation' do
    let(:image) { Fabricate(:image) }
    its(:is_public) { should be_falsey }

    context 'image with image_type' do
      let(:image) { Fabricate(:whisker_image) }
      it { should be_valid }
      its(:image_type) { should eq 'whisker' }
    end

    context 'public image' do
      let(:image) { Fabricate(:public_image) }
      it { should be_valid }
      its(:is_public) { should be_truthy }
    end
  end
end
