Fabricator(:image_set) do
  organization
  uploading_organization { Fabricate :organization }
  uploading_user { Fabricate :user }
  age 30
  gender 'male'
end

Fabricator(:image_set_with_images, from: :image_set) do
  images(count: 5)
  main_image { |attrs| attrs[:images].first }
end

Fabricator(:image_set_with_1_image, from: :image_set) do
  images(count: 1)
  main_image { |attrs| attrs[:images].first }
end
