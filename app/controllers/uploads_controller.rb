class UploadsController < ApiController
  def create
    @s3_direct_post = s3_bucket.presigned_post(
      key: unique_key,
      content_type: "image/jpeg",
      success_action_status: '201',
      acl: 'public-read'
    )

    upload = {
      id:     unique_id,
      url:    @s3_direct_post.url.to_s,
      fields: @s3_direct_post.fields
    }

    render json: UploadSerializer.new(upload)
  end

  private

  def unique_id
    @unique_id ||= SecureRandom.uuid
  end
  def unique_key
    id = unique_id
    now = Time.now
    year = now.year
    month = now.month
    day = now.day

    "uploads/#{year}/#{month}/#{day}/#{id}/${filename}"
  end

  def s3_bucket
    Aws::S3::Bucket.new(ENV['S3_BUCKET'])
  end
end
