class Users::SessionsController < Devise::SessionsController
  include Users::RackSessionFix
  respond_to :json

  private
  def respond_with(current_user, _opts = {})
    render json: {
      status: {
        code: 200, message: "Logged in successfully.",
        data: { user: UserSerializer.new(current_user).serializable_hash[:data][:attributes] }
      }
    }, status: :ok
  end
  def respond_to_on_destroy
    if request.headers["Authorization"].present?
      devise_secret_key = ENV["DEVISE_JWT_SECRET_KEY"] || Rails.application.credentials.devise[:secret_key]
      jwt_payload = JWT.decode(request.headers["Authorization"].split(" ").last, devise_secret_key).first
      current_user = User.find(jwt_payload["sub"])
    end

    if current_user
      render json: {
        status: 200,
        message: "Logged out successfully."
      }, status: :ok
    else
      render json: {
        status: 401,
        message: "Couldn't find an active session."
      }, status: :unauthorized
    end
  end
end