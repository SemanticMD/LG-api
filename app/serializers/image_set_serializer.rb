class ImageSetSerializer < BaseSerializer
  schema do
    type 'image_set'

    map_properties :id, :is_verified, :latitude, :longitude,
                   :gender, :age, :main_image_id

    property :user_id, item.uploading_user_id
    property :main_image_id, item.main_image.id if item.main_image
    property :has_cv_results, !item.cv_results.empty?

    entities :images, item.images, ImageSerializer
    entity :uploading_organization, item.uploading_organization, OrganizationSerializer
  end
end
