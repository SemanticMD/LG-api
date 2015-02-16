class Image < ActiveRecord::Base
  belongs_to :image_set, inverse_of: :images

  validates :url, presence: true
  validates :image_type,
    :inclusion  => { :in => [ 'cv', 'full-body', 'whisker', 'main-id', 'markings' ],
    :message    => "%{value} is not a valid image type" }

  scope :is_public, ->{ where(is_public: true) }

  def hide
    update(is_deleted: true)
  end
end
