class OrganizationsSerializer < BaseSerializer
  schema do
    type 'organizations'

    collection :organizations, item, OrganizationSerializer
  end
end
