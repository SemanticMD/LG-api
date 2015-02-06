class CvResult < ActiveRecord::Base
  belongs_to :cv_request
  belongs_to :image

  validates :cv_request, presence: true
  validates :image, presence: true
  validates :match_probability, inclusion: { in: 0.0..1.0 }

  has_one :image_set, through: :image
  has_one :lion, through: :image_set
end
