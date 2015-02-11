class Lion < ActiveRecord::Base
  belongs_to :organization

  has_many :image_sets, dependent: :nullify
  belongs_to :primary_image_set, class_name: 'ImageSet'

  validates :name, presence: true

  validate :primary_image_set_in_image_sets

  def self.create_from_image_set(image_set, name)
    lion = Lion.new(
      organization: image_set.organization,
      name: name,
      gender: image_set.gender,
      age: image_set.age
    )

    lion.image_sets << image_set
    lion.primary_image_set = image_set
    lion.save

    lion
  end

  private

  def primary_image_set_in_image_sets
    if primary_image_set && !image_sets.include?(primary_image_set)
      errors.add(:primary_image_set, 'must be included in image_sets')
    end
  end
end
