class OrganizationSerializer < BaseSerializer
  schema do
    type 'organization'

    map_properties :id, :name
  end
end
