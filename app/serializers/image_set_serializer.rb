class ImageSetSerializer < BaseSerializer
  schema do
    type 'image_set'

    map_properties :id, :is_verified, :latitude, :longitude, :main_image_id,
                   :gender, :age
    property :lion_name, item.lion && item.lion.name
    property :user_id, item.uploading_user_id

    entities :images, item.images, ImageSerializer
    entity :uploading_organization, item.uploading_organization, OrganizationSerializer
  end
end
