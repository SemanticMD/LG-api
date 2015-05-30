require 'rest-client'

module LG
  class CvRequestGenerator
    include Rails.application.routes.url_helpers

    CV_SERVER_URL = 'https://simbadx.herokuapp.com'
    CV_IDENTIFICATIONS_ENDPOINT = 'identifications'

    def initialize(cv_request)
      @cv_request = cv_request
    end

    def generate!
      if @cv_request
        if @cv_request.server_uuid
          puts "Request already submitted for cv Request id #{@cv_request.id}, server uuid is #{@cv_request.server_uuid}. Not submitting again."
        else
          response = request_response
          body = JSON.parse response.body
          server_uuid = body['id']
          save_server_uuid(server_uuid)

          puts "Saved Server UUID #{server_uuid} for Cv Request #{@cv_request.id} Scheduling 10 second polling for results"
          CvResultsWorker.schedule(@cv_request.id)
        end
      else
        puts 'Error: CvRequestGenerator cannot run without a CvRequest'
      end
    end

    private

    def images_data
      @cv_request.image_set.images.map do |image|
        {
          id: image.id.to_s,
          type: image.image_type,
          url: image.url
        }
      end
    end

    def search_lions
      Lion.by_gender(@cv_request.gender)
    end

    def lions
      search_lions.map do |lion|
        {
          id: lion.id.to_s,
          updated_at: lion.updated_at.utc.to_s,
          url: lion_url(lion)
        }
      end
    end

    def age
      if @cv_request.image_set.date_of_birth
        Time.now.year - @cv_request.image_set.date_of_birth.year
      else
        0
      end
    end

    def request_data
      {
        identification: {
          images: images_data,
          gender: @cv_request.gender,
          age: age,
          lions: lions
        }
      }.to_json
    end

    def request_response
      RestClient.post request_url, request_data
    end

    def request_url
      return CV_SERVER_URL + '/' + CV_IDENTIFICATIONS_ENDPOINT
    end

    def save_server_uuid(uuid)
      @cv_request.update(server_uuid: uuid, status: 'submitted')
    end
  end
end
