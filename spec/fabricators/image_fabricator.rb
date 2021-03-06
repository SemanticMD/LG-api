Fabricator(:image) do
  image_set
  image_type { 'cv' }
  url  'lionguardians.org'
end

Fabricator(:whisker_image, from: :image) do
  image_type { 'whisker' }
end

Fabricator(:public_image, from: :image) do
  is_public true
end

Fabricator(:new_image_wo_image_set, from: :image) do
   image_set { nil }
   image_type { 'cv' }
   url  'lionguardians.org'
 end
