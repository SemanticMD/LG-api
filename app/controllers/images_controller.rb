class ImagesController < ApiController
  before_filter :require_image, except: [:create]
  before_filter :require_image_ownership, except: [:create, :show]

  def create
    @image = Image.create(image_params)
    render json: ImageSerializer.new(@image)
  end

  def update
    @image.update(image_params)
    @image.save

    render json: ImageSerializer.new(@image)
  end

  def show
    render json: ImageSerializer.new(@image)
  end

  def destroy
    @image.hide

    render json: {}, status: 204
  end

  private

  def require_image
    @image = Image.find_by_id(params[:id])
    return error_not_found('image not found') unless @image
  end

  def require_image_ownership
    user_owns_image = @image.image_set.organization == current_user.organization
    return deny_access('user cannot delete image set') unless user_owns_image
  end

  def image_params
    params.require(:image).
      permit(:url,
             :image_type,
             :is_public,
             :image_set_id)
  end
end
