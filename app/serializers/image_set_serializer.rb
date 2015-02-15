class ImageSetSerializer < BaseSerializer
  schema do
    type 'image_set'

    map_properties :id, :is_verified, :latitude, :longitude,
                   :gender, :date_of_birth, :main_image_id

    property :user_id, item.uploading_user_id
    property :main_image_id, item.main_image.id if item.main_image
    property :has_cv_results, !item.cv_results.empty?
    property :cv_request_id, item.cv_request.id if item.cv_request

    entities :images, item.viewable_images(context[:current_user]), ImageSerializer

    entity :uploading_organization, item.uploading_organization, OrganizationSerializer

    # Avoid infinite circular embeds
    if context[:embedded]
      property :lion_id, item.lion.id if item.lion
    else
      if item.lion
        entity :lion, item.lion, LionSerializer, embedded: true
      end
    end
  end
end
