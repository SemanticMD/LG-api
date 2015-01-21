require 'oat/adapters/json_api'
class ImageSetSerializer < Oat::Serializer
  adapter Oat::Adapters::JsonAPI

  schema do
    type 'image_set'

    property :id, item.id
    property :lion_name, item.lion && item.lion.name
    property :organization, item.organization && item.organization.name
    property :is_verified, item.is_verified
    property :latitude, item.latitude
    property :longitude, item.longitude
    property :user_id, item.uploading_user_id
  end
end
