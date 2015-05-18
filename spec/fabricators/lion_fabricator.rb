Fabricator(:lion) do
  name { Faker::Name.name }
  image_sets { [Fabricate(:image_set_with_1_image)] }
  primary_image_set { |attrs| attrs[:image_sets].first }
end

Fabricator(:female_lion, from: :lion) do
  image_sets { [Fabricate(:female_image_set)] }
  primary_image_set { |attrs| attrs[:image_sets].first }
end

Fabricator(:male_lion, from: :lion) do
  image_sets { [Fabricate(:male_image_set)] }
  primary_image_set { |attrs| attrs[:image_sets].first }
end
