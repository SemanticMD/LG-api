Fabricator(:lion) do
  name { Faker::Name.name }
  image_sets { [Fabricate(:image_set_with_images)] }
  primary_image_set { |attrs| attrs[:image_sets].first }
end
