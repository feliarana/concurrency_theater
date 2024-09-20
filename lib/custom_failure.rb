class CustomFailure < Devise::FailureApp
  def redirect_url
     new_user_session_url(subdomain: "secure")
  end

  # You need to override respond to eliminate recall
  def respond
    self.status = 401
    self.content_type = "json"
    self.response_body = '{"error" : "authentication error"}'
  end
end
