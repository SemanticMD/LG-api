require 'rails_helper'
RSpec.describe CvResultsController, :type => :controller do
  let(:resource) { Fabricate :user }
  before { sign_in resource }
  subject { request.call }

  describe '#index' do
    let(:cv_request) { Fabricate :cv_request }
    let!(:cv_result) { Fabricate :cv_result, cv_request: cv_request }
    let(:image_set) { cv_request.image_set }
    let(:request) { ->{ get :index, { image_set_id: image_set.id } } }
    before { request.call }
    subject { response }

    it_behaves_like "an authenticated controller"

    it { expect(subject).to serialize_to(CvResultsSerializer, [cv_result]) }
  end
end
