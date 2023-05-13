class AuthenticationController < ApplicationController
    skip_before_action :authenticate_user, only: [:sign_in]
    
    def sign_in
        if user_params[:email].empty? || user_params[:password].empty?
            render json: { error: "Fields can't be blank", status: 500 }
        else
            @user = User.find_by_email(user_params[:email])
            if @user&.authenticate(user_params[:password])
                token = jwt_encode(user_id: @user.id)
                time = Time.now + 24.hours.to_i
                render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M"),
                               username: @user.username }, status: 200
            else
                render json: { error: "Invalid email/password credentials", status: 401 }
            end
        end
    end

    private
    def user_params
        params.permit(:email, :password)
    end

end
