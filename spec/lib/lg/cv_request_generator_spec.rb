require 'rails_helper'

describe LG::CvRequestGenerator do
  let(:cv_request) { Fabricate :cv_request }
  let(:server_uuid) { 'abcd-1234' }
  let(:response_data) {
    {
      'id' => server_uuid
    }
  }

  before {
    response = OpenStruct.new(body: response_data.to_json)
    allow_any_instance_of(LG::CvRequestGenerator).to receive(:request_response).and_return(response)
  }

  subject { LG::CvRequestGenerator.new(cv_request).generate! }

  describe 'creates request and saves uuid' do
    it {
      subject
      expect(cv_request.reload.server_uuid).to eq server_uuid
    }
  end

  describe 'includes lions with matching gender and no gender' do
    let!(:male_lion) { Fabricate(:male_lion) }
    let!(:female_lion) { Fabricate(:female_lion) }
    let!(:unknown_lion) { Fabricate(:lion) }

    let(:image_set) { female_lion.primary_image_set }
    let(:cv_request) { Fabricate(:cv_request, image_set: image_set) }
    let(:cv_request_generator) { LG::CvRequestGenerator.new(cv_request) }

    before do
      # precondition
      expect(unknown_lion.primary_image_set.gender).to be_nil
    end

    it 'has the correct fields' do
      cv_request_generator = LG::CvRequestGenerator.new(cv_request)
      request_data = JSON.parse(cv_request_generator.send(:request_data))

      lion_data = request_data['identification']['lions']
      lion_ids = lion_data.map {|datum| datum['id'].to_i }

      expect(lion_ids).to include(female_lion.id)
      expect(lion_ids).to include(unknown_lion.id)
      expect(lion_ids).not_to include(male_lion.id)
    end
  end

  describe 'adds cv_result_worker job' do
    it {
      expect { subject }.to change { CvResultsWorker.jobs.size }.by(1)
    }
  end
end
