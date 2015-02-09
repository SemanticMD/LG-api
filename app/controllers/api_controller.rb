class ApiController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :authenticate_user_from_token!
  before_filter :require_authenticated_user!

  rescue_from Errors::AuthenticationError, with: :deny_access

  private

  # Add _attributes to keys for nested json objects coming from client.
  def rename_nested_attributes(attrs, keys)
    keys.each do |key|
      attrs[:"#{key}_attributes"] = attrs.delete(key) if attrs.has_key?(key)
    end

    attrs
  end

  def error_not_found(message='not found')
    render status: 404, json: {
             code: '404',
             error: 'not_found',
             message: message
           }
  end

  def deny_access
    render status: 401, json: {
      code: '401',
      error: 'unathenticated',
      message: 'User must be signed in'
    }
  end

  def authenticate_user_from_token!
    # An 'Authorization: Token <token>,email=<email>'
    # header must be sent from ember
    authenticate_with_http_token do |token, options|
      email = options[:email].presence
      user  = email && User.find_by_email(email)

      if user && Devise.secure_compare(user.authentication_token, token)
        sign_in user, store: false
      end
    end
  end

  def require_authenticated_user!
    raise Errors::AuthenticationError if !user_signed_in?
  end

  def require_image_set
    @image_set = ImageSet.find_by_id(params[:id]) ||
                 ImageSet.find_by_id(params[:image_set_id])
    return error_not_found('image set not found') unless @image_set
  end

  def require_organization
    @organization = Organization.find_by_id(params[:organization_id])
    return error_not_found('org not found') unless @organization
  end

  def require_current_user_in_organization
    unless @organization == current_user.organization
      return error_not_found('user has no access to organization')
    end
  end
end
