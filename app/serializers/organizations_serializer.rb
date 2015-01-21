require 'oat/adapters/json_api'
class OrganizationsSerializer < Oat::Serializer
  adapter Oat::Adapters::JsonAPI

  schema do
    type 'organizations'

    collection :organizations, item, OrganizationSerializer
  end
end
