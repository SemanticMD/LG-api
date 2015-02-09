require 'rails_helper'

RSpec.describe Organization, :type => :model do
  subject { Fabricate :organization }
  it { should be_valid }
end
