Fabricator(:cv_request) do
  image_set { Fabricate :image_set }
  uploading_organization { |attrs| attrs[:image_set].uploading_organization }
  status 'created'
end
