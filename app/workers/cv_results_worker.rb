class CvResultsWorker
  include Sidekiq::Worker
  require 'lg/cv_results_reader'

  TIMEOUT_IN_SECONDS = 3

  def self.schedule(cv_request_id)
    self.perform_in(TIMEOUT_IN_SECONDS, cv_request_id)
  end

  def perform(cv_request_id)
    @cv_request = CvRequest.find(cv_request_id)
    if !@cv_request
      Rails.logger.error "CvResultsWorker: no Cv Request found with id #{cv_request_id}"
    elsif !@cv_request.server_uuid
      Rails.logger.error "CvResultsWorker: no Server UUID found for Cv Request #{cv_request_id}. Please submit another request to the CV Server"
    else
      LG::CvResultsReader.new(@cv_request).read!
    end
  end
end
