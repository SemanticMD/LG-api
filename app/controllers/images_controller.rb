class ImagesController < ApiController
  def create
    @image = Image.create(image_params)
    render json: ImageSerializer.new(@image)
  end

  def update
    @image = Image.find(params[:id])
    # TODO ERROR NOT FOUND unless @image

    @image.update(image_params)
    @image.save

    render json: ImageSerializer.new(@image)
  end

  def show
    @image = Image.find(params[:id])
    # TODO ERROR NOT FOUND unless @image

    render json: ImageSerializer.new(@image)
  end

  private

  def image_params
    params.require(:image).
      permit(:url,
             :image_type,
             :is_public,
             :image_set_id)
  end
end
