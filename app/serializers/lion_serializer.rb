class LionSerializer < BaseSerializer
  schema do
    type 'lion'

    map_properties :id, :name, :primary_image_set_id, :gender, :date_of_birth

    # Avoid infinite circular embeds
    if context[:embedded]
      property :image_set_ids, item.image_sets.map(&:id)
    else
      entities :image_sets, item.image_sets, ImageSetSerializer, embedded: true
    end

    entity   :organization, item.organization, OrganizationSerializer if item.organization
  end
end
