class SearchOptionsController < ApiController
  skip_before_filter :require_authenticated_user!

  def index
    render json: { search_options: LG::ImageSetMetaData::OPTIONS }
  end
end
