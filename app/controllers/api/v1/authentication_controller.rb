module Api
	module V1
		class AuthenticationController < ApplicationController
			skip_before_action :authenticate_user, only: [:sign_in]
			
			def sign_in
				if user_params[:email].blank? || user_params[:password].blank? 
					render json: { error: "Fields can't be blank" }, status: 422
				else
					@user = User.find_by_email(user_params[:email])
					if @user&.authenticate(user_params[:password])
							token = jwt_encode(user_id: @user.id)
							time = Time.now + 24.hours.to_i
							render json: {  id: @user.id, email: @user.email, username: @user.username, token: token, role: @user.role, avatar: @user.avatar_url,
														 fullname: "#{@user.first_name} #{@user.last_name}", exp: time.strftime("%m-%d-%Y %H:%M") }, status: 200
					else
							render json: { error: "Invalid email/password credentials" }, status: 401
					end
				end
			end
	
			private
			
			def user_params
				params.permit(:email, :password)
			end 
		end        
	end
end
