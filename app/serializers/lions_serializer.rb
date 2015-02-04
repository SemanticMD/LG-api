class LionsSerializer < BaseSerializer
  schema do
    type 'lions'

    collection :lions, item, LionSerializer
  end
end
