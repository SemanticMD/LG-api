class OrganizationsController < ApiController
  def index
    render json: OrganizationsSerializer.new(Organization.all)
  end

  def show
    @organization = Organization.find_by_id params[:id]
    return error_not_found('organization not found') unless @organization

    render json: OrganizationSerializer.new(@organization)
  end
end
