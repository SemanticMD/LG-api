class ImageSetsController < ApiController
  before_filter :require_image_set, except: [:create, :index]
  before_filter :require_image_set_ownership, only: [:destroy, :update]

  def index
    @image_sets = search_results
    render json: ImageSetsSerializer.new(@image_sets)
  end

  def create
    @image_set = ImageSet.create(expanded_params)

    render_image_set
  end

  def update
    @image_set.update(expanded_params)
    @image_set.save

    render_image_set
  end

  def show
    render_image_set
  end

  def destroy
    @image_set.destroy

    render json: {}, status: 204
  end

  private

  def search_results
    if search_params.has_key?(:lions)
      ImageSet.joins(:lion).where(search_params)
    else
      ImageSet.where(search_params)
    end
  end

  def search_params
    _params = params.permit(:age, :gender, :name, :organization_id)

    if _params[:organization_id]
      _params[:owner_organization_id] = _params.delete(:organization_id)
    end

    if _params[:name]
      name = _params.delete(:name)
      _params[:lions] = {name: name}
    end

    _params
  end

  def render_image_set
    render json: ImageSetSerializer.new(@image_set)
  end

  def expanded_params
    @uploading_user = User.find_by_id(image_set_params[:user_id])
    @uploading_organization = @uploading_user.organization
    _params = image_set_params.except(:user_id)
      .merge({:uploading_user => @uploading_user,
              :uploading_organization => @uploading_organization,
              :organization => @uploading_organization})

    rename_nested_attributes(_params, [:images, :main_image])
  end

  def image_set_params
    params.require(:image_set).
      permit(
          :id,
          :url,
          :lion_id,
          :user_id,
          :age,
          :name,
          :gender,
          :latitude,
          :longitude,
          :main_image_id,
          images:     [:id, :url, :image_type, :is_public])
  end
end
