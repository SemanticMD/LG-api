require 'oat/adapters/json_api'
class OrganizationSerializer < Oat::Serializer
  adapter Oat::Adapters::JsonAPI

  schema do
    type 'organization'

    property :id, item.id
    property :name, item.name
  end
end
