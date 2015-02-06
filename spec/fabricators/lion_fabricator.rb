Fabricator(:lion) do
  name { Faker::Name.name }
  image_sets { [Fabricate(:image_set_with_1_image)] }
  primary_image_set { |attrs| attrs[:image_sets].first }
end
