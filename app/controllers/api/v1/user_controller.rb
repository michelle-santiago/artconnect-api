
module Api
	module V1
		class UserController < ApplicationController
			skip_before_action :authenticate_user, only: [:sign_up]
			before_action :authorize_artist, only: [:about, :terms, :max_slot]

			def sign_up
				@user = User.new(user_params)
				if @user.valid?
					if @user.password == user_params[:password_confirmation]
						if @user.save
							@user.avatar.present? && @user.update!(avatar_url: url_for(@user.avatar))
							render json: @user, status: 201            
						else
							render json: { errors: @user.errors.full_messages}, status: 422
						end
					end
				else
					render json: { errors: @user.errors.full_messages}, status: 422   
				end		
			end

			def about
				if @current_user.update!(about: about_params[:about])
					render json: { about: @current_user.about}, status: 200
        else
          render json: { errors: @current_user.errors.full_messages}, status: 422   
				end
			end

			def terms
				if @current_user.update!(terms: terms_params[:terms])
					render json: { terms: @current_user.terms }, status: 200
        else
          render json: { errors: @current_user.errors.full_messages}, status: 422   
				end
			end

			def max_slot
				if @current_user.update!(max_slot: slot_params[:max_slot])
					render json: { max_slot: @current_user.max_slot }, status: 200
        else
          render json: { errors: @current_user.errors.full_messages}, status: 422   
				end
			end

			private

			def user_params
				params.permit(:first_name, :last_name, :username, :email, :password, :password_confirmation, :role, :avatar)
			end

			def about_params
				params.permit(:about)
			end

			def terms_params
				params.permit(:terms)
			end

			def slot_params
				params.permit(:max_slot)
			end
		end
	end
end
