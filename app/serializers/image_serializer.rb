require 'oat/adapters/json_api'
class ImageSerializer < Oat::Serializer
  adapter Oat::Adapters::JsonAPI

  schema do
    type 'image'

    property :url, item.url
    property :image_type, item.image_type
    property :is_public, item.is_public
  end
end
