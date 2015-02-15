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
      date_of_birth: image_set.date_of_birth
    )

    lion.image_sets << image_set
    lion.primary_image_set = image_set
    lion.save

    lion
  end

  def self.search(search_params)
    age_params = search_params.extract!(:dob_range_start, :dob_range_end)

    unless age_params.empty?
      dob_hash = { date_of_birth: (age_params[:dob_range_start]..age_params[:dob_range_end]) }
      search_params.merge!(dob_hash)
    end

    Lion.where(search_params)
  end

  private

  def primary_image_set_in_image_sets
    if primary_image_set && !image_sets.include?(primary_image_set)
      errors.add(:primary_image_set, 'must be included in image_sets')
    end
  end
end
