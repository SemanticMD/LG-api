class ImageSetsController < ApiController
  def create
    @image_set = ImageSet.create(expanded_params)
    render json: ImageSetSerializer.new(@image_set)
  end

  def update
    @image_set = ImageSet.find(params[:id])
    # TODO ERROR NOT FOUND UNLESS @image_set

    @image_set.update(expanded_params)
    @image_set.save

    render json: ImageSetSerializer.new(@image_set)
  end

  def show
    @image_set = ImageSet.find(params[:id])
    # TODO ERROR NOT FOUND UNLESS @image_set
    render json: ImageSetSerializer.new(@image_set)
  end

  private

  def expanded_params
    @uploading_user = User.find_by_id(image_set_params[:user_id])
    @uploading_organization = @uploading_user.organization
    image_set_params.except(:user_id)
      .merge({:uploading_user => @uploading_user,
              :uploading_organization => @uploading_organization})
  end

  def image_set_params
    params.require(:image_set).permit(:url,
                                      :lion,
                                      :user_id,
                                      :age,
                                      :name,
                                      :gender,
                                      :main_image_id,
                                      :latitude,
                                      :longitude)
  end
end
