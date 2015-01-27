class Image < ActiveRecord::Base
  belongs_to :image_set
  belongs_to :image_type

  validates :url, presence: true
end
