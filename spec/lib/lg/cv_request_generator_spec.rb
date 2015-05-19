require 'rails_helper'

describe LG::CvRequestGenerator do
  let(:cv_request) { Fabricate :cv_request }
  let(:server_uuid) { 'abcd-1234' }
  let(:response_data) {
    {
      'id': server_uuid
    }
  }

  before {
    response = OpenStruct.new(body: response_data.to_json)
    expect_any_instance_of(LG::CvRequestGenerator).to receive(:request_response).and_return(response)
  }

  subject { LG::CvRequestGenerator.new(cv_request).generate! }

  describe 'creates request and saves uuid' do
    it {
      subject
      expect(cv_request.reload.server_uuid).to eq server_uuid
    }
  end

  describe 'adds cv_result_worker job' do
    it {
      expect { subject }.to change { CvResultsWorker.jobs.size }.by(1)
    }
  end
end
