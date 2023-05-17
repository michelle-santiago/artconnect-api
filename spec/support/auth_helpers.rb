# require "jwt"
module AuthHelpers
  def jwt_encode(user)
    secret_key = Rails.application.secrets.secret_key_base.to_s  
    token = JWT.encode({ user_id: user.id, exp: 24.hours.from_now.to_i }, secret_key)
  end
end