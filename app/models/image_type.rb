class ImageType < ActiveRecord::Base
  has_many :images

  validates :name,
    :inclusion  => { :in => [ 'cv', 'full-body', 'whisker', 'main-id' ],
    :message    => "%{value} is not a valid image type" }
end
