class Lion < ActiveRecord::Base
  belongs_to :organization

  has_one :primary_image_set, class_name: 'ImageSet', dependent: :destroy
  has_many :image_sets, dependent: :nullify

  validates :name, presence: true, uniqueness: true

  validate :primary_image_set_in_image_sets

  before_destroy :unverify_image_sets, prepend: true

  # Search Params on lions table
  # All other search params are on primary image set
  LION_SEARCH_PARAMS = [:name, :organization_id]

  scope :by_gender, ->(gender) {
    if gender
      Lion.joins(:primary_image_set).where(image_sets: {gender: [gender, nil]})
    else
      Lion.all
    end
  }

  def self.create_from_image_set(image_set, name)
    lion = Lion.new(
      organization: image_set.organization,
      name: name
    )

    lion.image_sets << image_set
    lion.primary_image_set = image_set
    lion.save

    lion
  end

  def self.search(search_params)
    lion_params = {}
    LION_SEARCH_PARAMS.each do |key|
      lion_params[key] = search_params.delete key if search_params.has_key? key
    end

    unless search_params.empty?
      image_sets = ImageSet.search(search_params)
      lion_params[:primary_image_set] = image_sets.collect { |img| img.id }
    end

    Lion.where(lion_params)
  end

  def all_image_sets
    all_image_sets = self.image_sets + [self.primary_image_set]
    all_image_sets.compact.uniq
  end

  private

  def unverify_image_sets
    self.image_sets.each do |image_set|
      image_set.update(is_verified: false)
    end
  end

  def primary_image_set_in_image_sets
    if primary_image_set && !image_sets.include?(primary_image_set)
      errors.add(:primary_image_set, 'must be included in image_sets')
    end
  end
end
