class CvResultsController < ApiController
  before_filter :require_image_set

  def index
    @cv_results = @image_set.cv_results
    render json: CvResultsSerializer.new(@cv_results, current_user: current_user)
  end
end
