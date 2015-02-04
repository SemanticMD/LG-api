class LionSerializer < BaseSerializer
  schema do
    type 'lion'

    map_properties :id, :name, :primary_image_set_id

    # entity :primate_image_set, item.primary_image_set, ImageSetSerializer
    entities :image_sets, item.image_sets, ImageSetSerializer
    entity   :organization, item.organization, OrganizationSerializer if item.organization
  end
end
