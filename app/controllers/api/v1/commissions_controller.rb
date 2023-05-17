
module Api
	module V1
		class CommissionsController < ApplicationController
			before_action :authorize_artist, only: [:create, :update]

			def index
					if @current_user.role === "artist"
						@commissions = @current_user.commissions
					else
						@commissions = Commission.where("client_id = ?", @current_user.id)
					end
					render json: @commissions, status: 200 
			end

			def create
				@commission = @current_user.commissions.new(commission_params)
				if @commission.save
					render json: @commission, status: 201
				else 
					render json: { errors: @commission.errors.full_messages}, status: 422   
				end
			end

      def update
        @commission = @current_user.commissions.find(params[:id])
        if @commission.update(commission_params)
          render json: @commission, status: 201
        else
          render json: { errors: @commission.errors.full_messages}, status: 422   
        end
      end

			private 

			def commission_params
				params.permit(:kind, :price, :duration)
			end
		end
	end
end