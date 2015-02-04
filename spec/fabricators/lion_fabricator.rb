Fabricator(:lion) do
  name { Faker::Name.name }
  image_sets { [Fabricate(:image_set_with_images)] }
end
