
module Api
	module V1
		class UserController < ApplicationController
			skip_before_action :authenticate_user, only: [:sign_up]

			def sign_up
				@user = User.new(user_params)
				if @user.valid?
					if @user.password === user_params[:password_confirmation]
						if @user.save
							render json: @user, status: 201            
						else
							render json: { errors: @user.errors.full_messages}, status: 500
						end
					end
				else
					render json: { errors: @user.errors.full_messages}, status: 500   
				end
			end

			private

			def user_params
				params.permit(:first_name, :last_name, :username, :email, :password, :password_confirmation, :role)
			end
		end
	end
end
