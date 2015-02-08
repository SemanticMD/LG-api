class SessionsController < Devise::SessionsController
  skip_before_filter :verify_authenticity_token

  def create
    self.resource = warden.authenticate(auth_options.merge(store: false))

    if warden.authenticated?(:user)
      sign_in(resource_name, resource)
      data = {
        token: self.resource.authentication_token,
        email: self.resource.email,
        user:  self.resource.id
      }
      return render json: data, status: 201
    else
      return render json: {error: 'invalid login'}, status: 401
    end
  end
end
