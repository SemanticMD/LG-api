class CvRequestsController < ApiController
  def show
    @cv_request = CvRequest.find(params[:id])
    # TODO error not found unless cv_request

    render json: CvRequestSerializer.new(@cv_request)
  end

  def create
    @image_set = ImageSet.find(cv_request_params[:image_set_id])
    @uploading_organization = Organization.find(cv_request_params[:uploading_organization_id])

    # TODO Error unless @image_set and @uploading_organization

    # If there is already a CV Request for this image_set,
    # return it
    @cv_request = @image_set.cv_request
    unless @cv_request
      @cv_request = CvRequest.create(
        {
          image_set: @image_set,
          uploading_organization: @uploading_organization,
          status: 'created'
        }
      )
    end

    render json: CvRequestSerializer.new(@cv_request)
  end

  private

  def cv_request_params
    params.require(:cv_request).
      permit(:image_set_id, :uploading_organization_id)
  end
end
