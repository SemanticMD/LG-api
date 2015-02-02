class OrganizationSerializer < BaseSerializer
  schema do
    type 'organization'

    property :id, item.id
    property :name, item.name
  end
end
