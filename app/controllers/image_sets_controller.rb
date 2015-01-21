class ImageSetsController < ApiController
  def create
    @uploading_user = User.find_by_id(image_set_params[:user_id])
    @uploading_organization = @uploading_user.organization
    @expanded_params = image_set_params.except(:user_id)
                                       .merge({:uploading_user => @uploading_user,
                                               :uploading_organization => @uploading_organization})
    @image_set = ImageSet.create(@expanded_params)
    render json: ImageSetSerializer.new(@image_set)
  end

  private

  def image_set_params
    params.require(:image_set).permit(:url,
                                      :lion,
                                      :user_id,
                                      :latitude,
                                      :longitude)
  end
end
