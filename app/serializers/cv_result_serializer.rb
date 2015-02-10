class CvResultSerializer < BaseSerializer
  schema do
    type 'cv_request'

    map_properties :id, :match_probability, :image_id

    if item.lion
      entity :lion, item.lion, LionSerializer
    end

    entity :image_set, item.image_set, ImageSetSerializer
  end
end
