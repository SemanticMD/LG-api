require 'rails_helper'
RSpec.describe CvResultsController, :type => :controller do
  let(:resource) { Fabricate :user }
  before { sign_in resource }
  subject { request.call }

  describe '#index' do
    let!(:cv_result) { Fabricate :cv_result }
    let(:request) { ->{ get :index } }

    it_behaves_like "an authenticated controller"
    it { expect(subject).to serialize_to(CvResultsSerializer, [cv_result]) }
  end
end
