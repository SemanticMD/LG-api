class LionsController < ApiController
  before_filter :require_lion, except: [:create, :index]
  before_filter :require_lion_ownership, only: [:update, :destroy]
  skip_before_filter :require_authenticated_user!, only: [:index, :show]

  def show
    render_lion
  end

  def index
    @lions = Lion.search(search_params)

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

  def update
    @lion.update(creation_params)

    render_lion
  end

  def destroy
    @lion.destroy

    render json: {}, status: 204
  end

  private

  def require_lion
    @lion = Lion.find_by_id(params[:id])
    return error_not_found('lion not found') unless @lion
  end

  def require_lion_ownership
    is_owner = @lion.organization == current_user.organization
    return deny_access('user cannot edit lion') unless is_owner
  end

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
      :organization_id
    )
  end

  def search_params
    params.permit(:dob_range_start, :dob_range_end, :gender, :organization_id, :name)
  end
end
