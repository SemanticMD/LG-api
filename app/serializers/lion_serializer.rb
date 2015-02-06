class LionSerializer < BaseSerializer
  schema do
    type 'lion'

    map_properties :id, :name, :primary_image_set_id, :gender, :age

    entities :image_sets, item.image_sets, ImageSetSerializer
    entity   :organization, item.organization, OrganizationSerializer if item.organization
  end
end
