require 'rails_helper'

RSpec.describe SearchOptionsController, :type => :controller do
  describe '#index' do
    let(:request) { ->{ get :index } }
    subject { request.call }

    let(:expected) {
      {
        search_options: LG::ImageSetMetaData::OPTIONS
      }.to_json
    }

    it {
      expect(subject.body).to eq expected
    }

  end
end
