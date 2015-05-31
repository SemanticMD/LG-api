class CvRequestWorker
  include Sidekiq::Worker
  require 'lg/cv_request_generator'

  def perform(cv_request_id)
    @cv_request = CvRequest.find_by_id(cv_request_id)
    if @cv_request
      LG::CvRequestGenerator.new(@cv_request).generate!
    else
      Rails.logger.error "CvRequestWorker: no CV Request found with ID #{cv_request_id}"
    end
  end
end
