class Lion < ActiveRecord::Base
  belongs_to :organization

  has_many :image_sets, dependent: :nullify
  belongs_to :primary_image_set, class_name: 'ImageSet'

  validates :name, presence: true, uniqueness: true

  validate :primary_image_set_in_image_sets

  before_destroy :unverify_image_sets, prepend: true

  # Search Params on lions table
  # All other search params are on primary image set
  LION_SEARCH_PARAMS = [:name, :organization_id]

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
    age_params = search_params.extract!(:dob_range_start, :dob_range_end)

    unless age_params.empty?
      dob_start = DateTime.parse(age_params[:dob_range_start])
      dob_end = DateTime.parse(age_params[:dob_range_end])
      dob_hash = { date_of_birth: (dob_start..dob_end) }
      search_params.merge!(dob_hash)
    end

    params = {}
    LION_SEARCH_PARAMS.each do |key|
      params[key] = search_params.delete key if search_params.has_key? key
    end

    unless search_params.empty?
      params[:image_sets] = search_params
    end

    Lion.joins(:primary_image_set).where(params)
  end

  scope :by_gender, ->(gender) {
    if gender
      Lion.joins(:primary_image_set).where(image_sets: {gender: [gender, nil]})
    else
      Lion.all
    end
  }

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
