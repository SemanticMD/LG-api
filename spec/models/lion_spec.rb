require 'rails_helper'

RSpec.describe Lion, :type => :model do
  subject { Fabricate :lion }
  it { should be_valid }

  describe 'validations' do
    describe 'not valid is primary image set not in image sets' do
      subject { Fabricate.build(:lion, primary_image_set: Fabricate(:image_set)) }
      it { should_not be_valid }
    end
  end
end
