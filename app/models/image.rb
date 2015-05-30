class Image < ActiveRecord::Base
  belongs_to :image_set, inverse_of: :images
  dragonfly_accessor :full_image do
    copy_to(:thumbnail_image) {|i| i.thumb("225x150#") }
    copy_to(:main_image) {|i| i.thumb("300x300#") }
  end
  dragonfly_accessor :thumbnail_image
  dragonfly_accessor :main_image

  validates :url, presence: true
  validates :image_type,
    :inclusion  => { :in => [ 'cv', 'full-body', 'whisker', 'main-id', 'markings' ],
    :message    => "%{value} is not a valid image type" }

  scope :is_public, ->{ where(is_public: true) }

  after_save :generate_thumbnail, if: :needs_thumbnail?

  def hide
    update(is_deleted: true)
  end

  def thumbnail_url
    if thumbnail_image
      thumbnail_image.remote_url
    else
      url
    end
  end

  def main_url
    if main_image
      main_image.remote_url
    else
      url
    end
  end

  private

  def needs_thumbnail?
    !self.thumbnail_image
  end

  def generate_thumbnail
    puts "GENERATING THUMBNAIL FOR #{self.id}!!!!!!!!!!!!!!!!!!!!"
    ImageThumbnailWorker.perform_async(self.id)
  end
end
