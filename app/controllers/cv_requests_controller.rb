class CvRequestsController < ApiController
  before_filter :require_image_set, except: [:show]
  before_filter :require_image_set_ownership, except: [:show]

  def show
    @cv_request = CvRequest.find(params[:id])
    # TODO error not found unless cv_request

    render_cv_request
  end

  def create
    @cv_request = CvRequest.create_for_image_set(@image_set)

    render_cv_request
  end

  private

  def render_cv_request
    if @cv_request.valid?
      render json: CvRequestSerializer.new(@cv_request, current_user: current_user)
    else
      error_invalid_resource(@cv_request.errors)
    end
  end

  def require_image_set
    @image_set = ImageSet.find_by_id(cv_request_params[:image_set_id])
    return error_not_found('image set not found') unless @image_set
  end

  def cv_request_params
    params.require(:cv_request).
      permit(:image_set_id)
  end
end
