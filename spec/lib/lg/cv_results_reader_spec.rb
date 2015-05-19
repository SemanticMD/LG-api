require 'rails_helper'

describe LG::CvResultsReader do
  let(:server_uuid) { 'abcd-1234' }
  let(:cv_request) { Fabricate :cv_request, server_uuid: server_uuid }
  let(:lion) { Fabricate :lion }
  let(:match_probability) { 0.7 }
  let(:status) { 'finished' }
  let(:response_data) {
    {
      'id': server_uuid,
      'status': status,
      'lions': [
	{
          'id': lion.id,
          'confidence': match_probability
	}
      ]
    }
  }

  before {
    expect_any_instance_of(LG::CvResultsReader).to receive(:request_response).and_return(response_data.to_json)
  }

  subject { LG::CvResultsReader.new(cv_request).read! }

  describe 'creates request' do
    it {
      expect { subject }.to change { CvResult.count }.by(1)
      expect { subject }.to change { CvResultsWorker.jobs.size }.by(0)
    }

    it {
      cv_results = subject
      expect(cv_results.length).to eq 1
      cv_result = cv_results[0]
      expect(cv_result.cv_request).to eq cv_request
      expect(cv_result.lion).to eq lion
      expect(cv_result.match_probability).to eq match_probability

    }
  end

  describe 'creates another async job when status is not finished' do
    let(:status) { 'in progress...' }
    xit {
      expect { subject }.to change { CvResult.count }.by(0)
      expect { subject }.to change { CvResultsWorker.jobs.size }.by(1)
    }
  end
end
