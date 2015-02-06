require 'rails_helper'

RSpec.describe ImageSet, :type => :model do
  subject { Fabricate :image_set }
  it { should be_valid }

  describe 'validations' do
    describe 'main image not in image set' do
      subject { Fabricate.build(:image_set, main_image: Fabricate(:image)) }
      it { should_not be_valid }
    end
  end

  describe 'main image from image set' do
    subject { Fabricate :image_set_with_images }
    it { should be_valid }
  end
end
