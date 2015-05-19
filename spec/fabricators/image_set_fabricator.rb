Fabricator(:image_set) do
  organization
  uploading_organization { Fabricate :organization }
  uploading_user { Fabricate :user }
  date_of_birth 30.years.ago
end

Fabricator(:female_image_set, from: :image_set) do
  gender 'female'
end

Fabricator(:male_image_set, from: :image_set) do
  gender 'male'
end

Fabricator(:image_set_with_images, from: :image_set) do
  images(count: 5)
  main_image {
    |attrs| attrs[:images].first.tap{
      |image| image.update(is_public: true)
    }
  }
end

Fabricator(:image_set_with_1_image, from: :image_set) do
  images(count: 1)
  main_image {
    |attrs| attrs[:images].first.tap {
      |image| image.update(is_public: true)
    }
  }
end
