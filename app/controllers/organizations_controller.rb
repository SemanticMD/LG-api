class OrganizationsController < ApiController
  def index
    render json: OrganizationsSerializer.new(Organization.all)
  end
end
