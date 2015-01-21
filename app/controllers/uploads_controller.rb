class UploadsController < ApiController
  def create
    id = SecureRandom.uuid

    @s3_direct_post = S3_BUCKET.presigned_post(
      key: "uploads/#{id}/${filename}",
      success_action_status: 201,
      acl: :public_read
    )

    json = {
      id:     id,
      url:    @s3_direct_post.url.to_s,
      fields: @s3_direct_post.fields
    }

    render json: {upload: json}
  end

  private

  def upload_params
    params[:upload]
  end
end
