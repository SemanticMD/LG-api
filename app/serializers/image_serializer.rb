class ImageSerializer < BaseSerializer
  schema do
    type 'image'

    map_properties :id, :url, :image_type, :is_public
  end
end
