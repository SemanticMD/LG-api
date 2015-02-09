class ImageSetsSerializer < BaseSerializer
  schema do
    type 'image_sets'
    collection :image_sets, item, ImageSetSerializer
  end
end
