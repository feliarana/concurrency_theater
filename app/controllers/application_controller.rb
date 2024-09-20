class ApplicationController < ActionController::API
  # before_action :authenticate_user!
  # include ActionController::RequestForgeryProtection
  # protect_from_forgery with: :exception
  # protect_from_forgery with: :null_session
  before_action :configure_permitted_parameters, if: :devise_controller?
  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name email])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name email])
  end
end
