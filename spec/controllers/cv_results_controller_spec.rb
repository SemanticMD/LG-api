require 'rails_helper'
RSpec.describe CvResultsController, :type => :controller do

  describe '#index' do
    let!(:cv_result) { Fabricate :cv_result }
    let(:request) { ->{ get :index } }
    before { request.call }
    subject { response }
    it { expect(subject).to serialize_to(CvResultsSerializer, [cv_result]) }
  end
end
