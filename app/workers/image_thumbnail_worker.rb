class ImageThumbnailWorker
  include Sidekiq::Worker

  MAX_TRIES = 2
  RETRY_DELAY_SECONDS = 3

  def perform(image_id, try_count=0)
    Rails.logger.info "[thumbnail] Worker Generating thumbnail for Image #{image_id}"
    @image = Image.find_by_id image_id
    if !@image
      Rails.logger.info "[thumbnail] Could not find image id #{image_id}"
      schedule_retry(image_id, try_count)
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

  def schedule_retry(image_id, try_count)
    if try_count < MAX_TRIES
      Rails.logger.info "[thumbnail] retrying #{image_id} (count: #{try_count})"
      self.class.perform_in(RETRY_DELAY_SECONDS, image_id, try_count+1)
    else
      Rails.logger.info "[thumbnail] tried #{image_id} #{try_count} times, not trying again"
    end
  end
end
