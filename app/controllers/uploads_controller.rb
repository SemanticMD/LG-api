class UploadsController < ApiController
  def create
    id = SecureRandom.uuid
    now = Time.now
    year = now.year
    month = now.month
    day = now.day

    @s3_direct_post = s3_bucket.presigned_post(
      key: "uploads/#{year}/#{month}/#{day}/#{id}/${filename}",
      content_type: "image/jpeg",
      success_action_status: '201',
      acl: 'public-read'
    )

    upload = {
      id:     id,
      url:    @s3_direct_post.url.to_s,
      fields: @s3_direct_post.fields
    }

    render json: UploadSerializer.new(upload)
  end

  private

  def s3_bucket
    Aws::S3::Bucket.new(ENV['S3_BUCKET'])
  end

  def upload_params
    params[:upload]
  end
end
