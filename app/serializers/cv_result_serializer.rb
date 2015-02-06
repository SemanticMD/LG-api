class CvResultSerializer < BaseSerializer
  schema do
    type 'cv_request'

    map_properties :id, :match_probability, :image_id

    if item.lion
      map_property :image_set_id
      entity :lion, item.lion, LionSerializer
    else
      entity :image_set, item.image_set, ImageSetSerializer
    end
  end
end
