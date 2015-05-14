require 'rest-client'

module LG
  class CvResultsReader

    CV_SERVER_URL = 'https://simbadx.herokuapp.com'
    CV_RESULTS_ENDPOINT = 'results'

    def initialize(cv_request)
      @cv_request = cv_request
    end

    def read!
      response = JSON.parse(request_response)

      if (response['status'] == 'finished')
        lions = response['lions']
        puts "Received results for Cv Request #{@cv_request.id}, UUID: #{@cv_request.server_uuid}, number of lions: #{lions.size}"
        create_cv_results lions
      else
        puts "No results yet for Cv Request #{@cv_request.id}, UUID: #{@cv_request.server_uuid}. Will poll again."
        CvResultsWorker.schedule(@cv_request.id)
      end
    end

    private

    def create_cv_results(lions)
      lions.map do |lion|
        CvResult.create(
          cv_request: @cv_request,
          match_probability: lion['confidence'],
          lion: Lion.find(lion['id'])
        )
      end
    end

    def request_response
      RestClient.get request_url
    end

    def request_url
      CV_SERVER_URL + '/' + CV_RESULTS_ENDPOINT + '/' + @cv_request.server_uuid
    end
  end
end
