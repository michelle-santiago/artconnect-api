
module Api
	module V1
		class CommissionsController < ApplicationController
			before_action :authorize_artist, only: [:create, :update]

			def index
				render json: { welcome: "commission" }, status: 201 
			end

			def create
				@commission = @current_user.commissions.new(commission_params)
				if @commission.save
					render json: @commission, status: 201
				else 
					render json: { errors: @commission.errors.full_messages}, status: 500   
				end
			end

      def update
        @commission = @current_user.commissions.find(params[:id])
        if @commission.update(commission_params)
          render json: @commission, status: 201
        else
          render json: { errors: @request.errors.full_messages}, status: 500   
        end
      end

			private 

			def commission_params
				params.permit(:kind, :price, :duration)
			end
		end
	end
end