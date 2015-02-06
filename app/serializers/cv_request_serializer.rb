class CvRequestSerializer < BaseSerializer
  schema do
    type 'cv_request'

    map_properties :id, :status

    entity :image_set, item.image_set, ImageSetSerializer
    entity :uploading_organization, item.uploading_organization, OrganizationSerializer
  end
end
