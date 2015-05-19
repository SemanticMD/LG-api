class CvResultSerializer < BaseSerializer
  schema do
    type 'cv_request'

    map_properties :id, :match_probability

    if item.lion
      entity :lion, item.lion, LionSerializer

      # Lion serializer will serialize all image sets
      # so just include image_set_id here.
      property :image_set_id, item.image_set.try(:id)
      property :image_id, item.image.try(:id)
    end
  end
end
