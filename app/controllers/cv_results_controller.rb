class CvResultsController < ApiController
  def index
    @cv_results = CvResult.all
    render json: CvResultsSerializer.new(@cv_results)
  end
end
