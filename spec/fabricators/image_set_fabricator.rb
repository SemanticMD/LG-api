Fabricator(:image_set) do
  organization
  uploading_organization { Fabricate :organization }
  uploading_user { Fabricate :user }
end

Fabricator(:image_set_with_images, from: :image_set) do
  images(count: 5)
  main_image { |attrs| attrs[:images].first }
end
