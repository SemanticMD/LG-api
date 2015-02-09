require 'rails_helper'

RSpec.describe User, :type => :model do
  subject { Fabricate :user }
  it { should be_valid }

  describe 'validations' do
    describe 'requires an organization' do
      subject { Fabricate.build(:user, organization: nil) }
      it { should_not be_valid}
    end

    describe 'requires unique email' do
      let(:first_user) { Fabricate(:user) }
      subject { Fabricate.build(:user, email: first_user.email) }
      it { should_not be_valid }
    end
  end
end
