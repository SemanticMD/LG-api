class ImageThumbnailWorker
  include Sidekiq::Worker

  def perform(image_id)
    @image = Image.find_by_id image_id
    return if !@image

    return if !@image.url
    return if @image.thumbnail_image

    @image.full_image_url = @image.url
    @image.save!

    @image.url = @image.full_image.remote_url
    @image.save!

    # delete file at `url`
  end
end
