class Lion < ActiveRecord::Base
  belongs_to :organization

  has_many :image_sets, dependent: :nullify
  belongs_to :primary_image_set, class_name: 'ImageSet'

  validates :name, uniqueness: true
end
