class UploadSerializer < BaseSerializer
  schema do
    type 'upload'

    property :id, item[:id]
    property :url, item[:url]
    property :fields, item[:fields]
  end
end
