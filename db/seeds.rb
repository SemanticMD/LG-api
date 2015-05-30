lion_img_url_1 = "https://lg-201-created-development.s3.amazonaws.com/uploads%2Fe3f10f18-d176-41a7-84b9-0b2c5fef81e7%2F38yrs_Sikiria-300x300.jpg"
lion_img_url_2 = "https://lg-201-created-development.s3.amazonaws.com/uploads%2Fc949fccd-1784-42bd-8ce4-99035c887874%2F58yrs_male_Sikiria.jpg"
lion_img_url_3 = "https://lg-201-created-development.s3.amazonaws.com/uploads%2F7d89e575-29b0-4012-85b0-280ae741e620%2FLion_waiting_in_Namibia.jpg"

lg = Organization.create(name: 'Lion Guardians')
org201 = Organization.create(name: '201 Created')
admin_user = AdminUser.create(email: 'justin@lg.org', password: 'password')
user = User.create(email: admin_user.email, password: admin_user.password, organization: lg)

=begin


image_set_1 = ImageSet.create(
  {
    uploading_organization: lg,
    uploading_user: user,
    organization: lg,
    latitude: -2.6527,
    longitude: 37.26058,
    date_of_birth: 30.years.ago,
    gender: 'male',
    images_attributes: [
      {url: lion_img_url_1, is_public: true, image_type: 'cv'},
      {url: lion_img_url_2, is_public: true, image_type: 'whisker'},
      {url: lion_img_url_3, is_public: true, image_type: 'markings'}
    ],
    tags: ['EAR_MARKING_LEFT', 'EYE_DAMAGE_LEFT', 'MOUTH_MARKING_LEFT', 'NOSE_COLOUR_BLACK', 'TAIL_MARKING_MISSING_TUFT', 'TEETH_BROKEN_CANINE_LEFT', 'TEETH_BROKEN_INCISOR_LEFT', 'SCARS_BODY_LEFT']
  }
)

image_set_1.main_image = image_set_1.images.first
image_set_1.save

lion_1 = Lion.create({name: 'Simba', organization: lg })
lion_1.image_sets << image_set_1
lion_1.primary_image_set = image_set_1
lion_1.save


user2 = User.create(email: 'isaac@lg.org', password: 'password', organization: org201)

image_set_2 = ImageSet.create(
  {
    uploading_organization: org201,
    uploading_user: user2,
    organization: org201,
    latitude: -2.6527,
    longitude: 37.26058,
    date_of_birth: 10.years.ago,
    gender: 'female',
    images_attributes: [
      {url: lion_img_url_1, is_public: true, image_type: 'cv'},
      {url: lion_img_url_2, is_public: true, image_type: 'whisker'},
      {url: lion_img_url_3, is_public: true, image_type: 'markings'}
    ]
  }
)

image_set_2.main_image = image_set_2.images.last
image_set_2.save

lion_2 = Lion.create({name: 'Lauren', organization: org201 })
lion_2.image_sets << image_set_2
lion_2.primary_image_set = image_set_2
lion_2.save

image_set_3 = ImageSet.create(
  {
    uploading_organization: lg,
    uploading_user: user,
    organization: lg,
    latitude: -2.6527,
    longitude: 37.26058,
    date_of_birth: 14.years.ago,
    images_attributes: [
      {url: lion_img_url_1, is_public: true, image_type: 'cv'},
      {url: lion_img_url_2, is_public: true, image_type: 'whisker'},
      {url: lion_img_url_3, is_public: true, image_type: 'markings'}
    ]
  }
)

image_set_3.main_image = image_set_3.images[1]
image_set_3.save
lion_1.image_sets << image_set_3

image_set_cv = ImageSet.create(
  {
    uploading_organization: lg,
    uploading_user: user,
    organization: lg,
    latitude: -2.6527,
    longitude: 37.26058,
    date_of_birth: 14.years.ago,
    images_attributes: [
      {url: lion_img_url_1, is_public: true, image_type: 'cv'},
      {url: lion_img_url_2, is_public: true, image_type: 'whisker'},
      {url: lion_img_url_3, is_public: true, image_type: 'markings'}
    ]
  }
)

image_set_cv.main_image = image_set_cv.images.where(image_type: 'markings').first
image_set_cv.save

cv_request = CvRequest.create(
  image_set: image_set_cv,
  uploading_organization: lg,
  status: 'results_received'
)

CvResult.create(
  cv_request: cv_request,
  match_probability: 0.8,
  lion: lion_1
)

CvResult.create(
  cv_request: cv_request,
  match_probability: 0.7,
  lion: lion_2
)
=end
