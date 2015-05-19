class CvResult < ActiveRecord::Base
  belongs_to :cv_request
  belongs_to :lion

  validates :cv_request, presence: true
  validates :lion, presence: true
  validates :match_probability, inclusion: { in: 0.0..1.0 }

  def image_set
    lion.primary_image_set
  end

  def image
    image_set.main_image
  end

  scope :by_probability, ->{ order('match_probability DESC') }
end
