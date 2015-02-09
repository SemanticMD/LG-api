require 'rails_helper'

RSpec.describe AdminUser, :type => :model do
  subject { Fabricate :admin_user }
  it { should be_valid }
end
