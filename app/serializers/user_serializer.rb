class UserSerializer < BaseSerializer
  schema do
    type 'user'

    map_properties :id, :email

    entity :organization, item.organization, OrganizationSerializer if item.organization
  end
end
