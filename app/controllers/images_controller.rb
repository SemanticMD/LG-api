class ImagesController < ApiController
  def create
    @image = Image.create(image_params)
    render json: ImageSerializer.new(@image)
  end

  def show
    @image = Image.find(params[:id])
    render json: ImageSerializer.new(@image)
  end

  private

  def image_params
    params.require(:image).permit(:url, :image_type, :image_set_id)
  end
end
