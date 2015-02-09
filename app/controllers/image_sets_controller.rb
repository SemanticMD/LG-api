class ImageSetsController < ApiController
  before_filter :require_image_set, except: [:create, :index]
  before_filter :require_organization, only: [:index]
  before_filter :require_current_user_in_organization, only: [:index]

  def index
    @image_sets = @organization.image_sets
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

  private

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
          :url,
          :lion,
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
