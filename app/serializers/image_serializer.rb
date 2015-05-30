class ImageSerializer < BaseSerializer
  schema do
    type 'image'

    map_properties :id,
      :image_type,
      :is_public,
      :url,
      :thumbnail_url,
      :main_url
  end
end
