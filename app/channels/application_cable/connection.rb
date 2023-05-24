module ApplicationCable
  class Connection < ActionCable::Connection::Base

  # note to self! for authorization later

  #   include JwtToken
  #   identified_by :current_user
    
  #   def connect
  #     self.current_user = authenticate_user
  #   end

  #   private

  #   def authenticate_user
  #       header = request.params[:token]
  #       begin 
  #           @decoded = jwt_decode(header)
  #           @current_user = User.find(@decoded[:user_id])
  #       rescue ActiveRecord::RecordNotFound => e
  #           render json: { errors: e.message }, status: 404
  #       rescue JWT::DecodeError => e
  #           render json: { errors: e.message }, status: 401
  #       end
  #   end
  end
end
