lion_img_url_1 = "https://lg-201-created-development.s3.amazonaws.com/uploads%2Fe3f10f18-d176-41a7-84b9-0b2c5fef81e7%2F38yrs_Sikiria-300x300.jpg"
lion_img_url_2 = "https://lg-201-created-development.s3.amazonaws.com/uploads%2Fc949fccd-1784-42bd-8ce4-99035c887874%2F58yrs_male_Sikiria.jpg"
lion_img_url_3 = "https://lg-201-created-development.s3.amazonaws.com/uploads%2F7d89e575-29b0-4012-85b0-280ae741e620%2FLion_waiting_in_Namibia.jpg"

lg = Organization.create(name: 'Lion Guardians')
org201 = Organization.create(name: '201 Created')
user = User.create(email: 'email@d.com', password: 'password', organization: lg)

image_set_1 = ImageSet.create(
  {
    uploading_organization: lg,
    uploading_user: user,
    images_attributes: [
      {url: lion_img_url_1, image_type: 'cv'},
      {url: lion_img_url_2, image_type: 'whisker'},
      {url: lion_img_url_3, image_type: 'markings'}
    ]
  }
)

image_set_1.main_image = image_set_1.images.first
image_set_1.save

lion_1 = Lion.create({name: 'Simba', gender: 'male', age: '24', organization: lg })
lion_1.image_sets << image_set_1
lion_1.primary_image_set = image_set_1
lion_1.save


user2 = User.create(email: 'u2@d.com', password: 'password', organization: org201)

image_set_2 = ImageSet.create(
  {
    uploading_organization: org201,
    uploading_user: user2,
    images_attributes: [
      {url: lion_img_url_1, image_type: 'cv'},
      {url: lion_img_url_2, image_type: 'whisker'},
      {url: lion_img_url_3, image_type: 'markings'}
    ]
  }
)

image_set_2.main_image = image_set_2.images.last
image_set_2.save

lion_2 = Lion.create({name: 'Lauren', gender: 'female', age: '26', organization: org201 })
lion_2.image_sets << image_set_2
lion_2.primary_image_set = image_set_2
lion_2.save
