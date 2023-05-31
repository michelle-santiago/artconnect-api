
module Api
	module V1
		class CommissionsController < ApplicationController
			before_action :authorize_artist, only: [:create, :update, :add_process, :update_process, :complete_process, :complete_status]

			def index
				if @current_user.role == "artist"
					@commissions = @current_user.commissions
				else
					@commissions = @current_user.commissioned_arts
				end
				render json: @commissions, status: 200 
			end

			def create
				@commission = @current_user.commissions.new(commission_params)
				if @commission.save
					@commission.image.present? && @commission.update!(image_url: url_for(@commission.image))
					render json: @commission, status: 201
				else 
					render json: { errors: @commission.errors.full_messages}, status: 422   
				end
			end

      def update
        @commission = @current_user.commissions.find(params[:id])
        if @commission.update!(commission_params)
					@commission.image.present? && @commission.update!(image_url: url_for(@commission.image))
          render json: @commission, status: 201
        else
          render json: { errors: @commission.errors.full_messages}, status: 422   
        end
      end

			def show
				@commissions = Commission.where(artist_id: params[:id], status: nil)
				render json: @commissions, status: 200 
			end

			def add_process
				@commission = @current_user.commissions.find(params[:id])
				if @commission.process.last["status"] == "pending"
					render json: { error: "You have a pending process below, complete it first"}, status: 422
				else
					if @commission.process_repeatable?(process_params)
						if @commission.add_process!(process_params)
							render json: @commission, status: 200
						else
							render json: { errors: @commission.errors.full_messages}, status: 422   
						end
					else
						render json: { error: "#{process_params[:phase]} already exists!" }, status: 422
					end
				end
			end

			def update_process
				@commission = @current_user.commissions.find(params[:id])
				if @commission.process.last["status"] == "completed"
					render json: { error: "Process already completed, you cannot edit anymore"}, status: 422
				else
					if @commission.update_process!(process_params.except(:phase))
						render json: @commission, status: 200
					else
						render json: { errors: @commission.errors.full_messages}, status: 422   
					end
				end
			end

			def complete_process
				@commission = @current_user.commissions.find(params[:id])
				if @commission.process.last["status"] == "completed"
					render json: { error: "Process already completed, you cannot edit anymore"}, status: 422
				else
					if @commission.complete_process!
						render json: @commission, status: 200 
					end
				end
			end

			def complete_status
        @commission =  @current_user.commissions.find(params[:id])
        if @commission.update!(status: "completed")
          render json: @commission, status: 200
        else
          render json: { errors: @commission.errors.full_messages}, status: 422   
        end		
			end

			private 

			def commission_params
				params.permit(:kind, :price, :duration, :image)
			end

			def process_params
				params.permit(:phase, :p_price, :remarks, :payment_status, :p_status)
			end

		end
	end
end