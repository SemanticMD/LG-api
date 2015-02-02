class Image < ActiveRecord::Base
  belongs_to :image_set

  validates :url, presence: true
  validates :image_type,
    :inclusion  => { :in => [ 'cv', 'full-body', 'whisker', 'main-id', 'markings' ],
    :message    => "%{value} is not a valid image type" }
end
