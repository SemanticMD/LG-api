class CvResultSerializer < BaseSerializer
  schema do
    type 'cv_request'

    map_properties :id, :match_probability, :image_id

    if item.lion
      entity :lion, item.lion, LionSerializer
      property :image_set_id, item.image_set.id
    else
      entity :image_set, item.image_set, ImageSetSerializer, embedded: true
    end
  end
end
