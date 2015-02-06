class CvResultSerializer < BaseSerializer
  schema do
    type 'cv_request'

    map_properties :id, :match_probability

    entity :image, item.image, ImageSerializer
  end
end
