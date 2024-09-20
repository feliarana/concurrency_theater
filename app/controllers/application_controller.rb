class ApplicationController < ActionController::API
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def current_user
    @current_user ||= User.find_by(jti: user_jti)
  end

  def user_jti
    jwt_token = request.headers["Authorization"].split(" ").last
    secret_key = ENV["DEVISE_JWT_SECRET_KEY"] || Rails.application.credentials.devise[:secret_key]
    raise "jwt_token is nil" if jwt_token.nil?

    JWT.decode(jwt_token, secret_key, true, { algorithm: "HS256" })[0]["jti"]
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name email])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name email])
  end
end
