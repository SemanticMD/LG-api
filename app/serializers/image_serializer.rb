class ImageSerializer < BaseSerializer
  schema do
    type 'image'

    map_properties :id,
      :image_type,
      :is_public,
      :thumbnail_url,
      :main_url

    property :url, item.full_url
  end
end
