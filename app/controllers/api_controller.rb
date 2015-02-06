class ApiController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :authenticate_user_from_token!

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

  private

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
end
