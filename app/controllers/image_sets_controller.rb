class ImageSetsController < ApiController
  before_filter :require_image_set, except: [:create, :index]
  before_filter :require_image_set_ownership, only: [:destroy, :update]

  def index
    @image_sets = search_results
    render json: ImageSetsSerializer.new(@image_sets, current_user: current_user)
  end

  def create
    @image_set = ImageSet.create(creation_params)

    render_image_set
  end

  def update
    _params = update_params

    old_lion = @image_set.lion
    new_lion_id = _params[:lion_id]
    if old_lion && new_lion_id &&old_lion.id.to_s != new_lion_id.to_s
      return error_invalid_resource(
               lion: ["#{@image_set.id} already associated with a different lion #{old_lion.name}"]
             )
    else
      @image_set.update(_params)
      @image_set.save

      render_image_set
    end
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
    if @image_set.valid?
      render json: ImageSetSerializer.new(@image_set, current_user: current_user)
    else
      error_invalid_resource(@image_set.errors)
    end
  end

  def update_params
    _params = image_set_params

    if _params[:organization_id]
      _params[:owner_organization_id] = _params.delete(:organization_id)
    end

    rename_nested_attributes(_params, [:images, :main_image])
  end

  def creation_params
    @uploading_user = current_user
    @uploading_organization = @uploading_user.organization

    _params = image_set_params.except(:organization_id)
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
          :date_of_birth,
          :organization_id,
          :name,
          :gender,
          :latitude,
          :longitude,
          :main_image_id,
          images:     [:id, :url, :image_type, :is_public])
  end
end
