class ImageSetSerializer < BaseSerializer
  schema do
    type 'image_set'

    map_properties :id, :is_verified, :latitude, :longitude,
                   :gender, :date_of_birth, :main_image_id,
                   :uploading_organization_id, :notes

    property :organization_id, item.organization.id
    property :user_id, item.uploading_user_id
    property :main_image_id, item.main_image.id if item.main_image
    property :has_cv_results, !item.cv_results.empty?
    property :cv_request_id, item.cv_request.id if item.cv_request
    property :has_cv_request, item.cv_request.present?
    property :tags, item.tags if item.tags.present?
    property :date_stamp, item.date_stamp.strftime("%Y-%m-%d") if item.date_stamp

    entities :images, item.viewable_images(context[:current_user]), ImageSerializer

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
