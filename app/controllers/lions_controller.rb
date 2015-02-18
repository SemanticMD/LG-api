class LionsController < ApiController
  def show
    @lion = Lion.find(params[:id])

    render_lion
  end

  def index
    @lions = Lion.where(search_params)

    render_lions
  end

  def create
    @image_set = ImageSet.find_by_id(creation_params[:primary_image_set_id])
    return error_invalid_resource(primary_image_set: ['for lion creation not found']) unless @image_set
    if @image_set.lion.present?
      return error_invalid_resource(primary_image_set: ['already associated with another lion'])
    end


    @name = creation_params[:name]
    @lion = Lion.create_from_image_set(@image_set, @name)

    render_lion
  end

  private

  def render_lion
    if @lion.valid?
      render json: LionSerializer.new(@lion, current_user: current_user)
    else
      error_invalid_resource(@lion.errors)
    end
  end

  def render_lions
    render json: LionsSerializer.new(@lions, current_user: current_user)
  end

  def creation_params
    params.require(:lion).permit(
      :primary_image_set_id,
      :name,
      :age,
      :gender,
      :organization_id
    )
  end

  def search_params
    params.permit(:age, :gender, :organization_id, :name)
  end
end
