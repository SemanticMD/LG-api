class ImageThumbnailWorker
  include Sidekiq::Worker

  def perform(image_id)
    Rails.logger.info "[thumbnail] Worker Generating thumbnail for Image #{image_id}"
    @image = Image.find_by_id image_id
    if !@image
      Rails.logger.info "[thumbnail] Could not find image id #{image_id}"
      return 
    end

    if !@image.url
      Rails.logger.info "[thumbnail] no url for image id #{image_id}"
      return
    end
    if @image.thumbnail_image
      Rails.logger.info "[thumbnail] already has thumbnail for image id #{image_id}"
      return
    end

    Rails.logger.info "[thumbnail] worker successfully generating thumbnail for #{image_id}"
    @image.full_image_url = @image.url
    @image.save!

    @image.url = @image.full_image.remote_url
    @image.save!

    # delete file at `url`
  end
end
