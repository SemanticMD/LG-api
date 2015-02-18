class CvRequestSerializer < BaseSerializer
  schema do
    type 'cv_request'

    map_properties :id, :status, :uploading_organization_id

    entity :image_set, item.image_set, ImageSetSerializer
  end
end
