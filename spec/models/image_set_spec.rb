require 'rails_helper'

RSpec.describe ImageSet, :type => :model do
  subject { Fabricate :image_set }
  it { should be_valid }
end
