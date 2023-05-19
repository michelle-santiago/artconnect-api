module Api
	module V1
		class RequestsController < ApplicationController

			before_action :authorize_client, only: [:create, :cancel]
      before_action :authorize_artist, only: [:update, :update_payment]

			def index
        if @current_user.role === "client"
          @requests = @current_user.requests
        else
          @requests = Request.where("artist_id = ?", @current_user.id)
        end
				render json: @requests, status: 200 
			end

			def create
				@request = @current_user.requests.new(request_params)
				if @request.save
					render json: @request, status: 201
				else 
					render json: { errors: @request.errors.full_messages}, status: 500   
				end
			end

      def update
        @request = Request.where("id = ? AND artist_id = ?", params[:id], @current_user.id).first
        if @request.update!(status_params)
          if @request.status === "approved"
            @commission = @current_user.commissions.find_by_request_id(@request.id)
            if @commission.blank?
              @commission_created = @current_user.commissions.create!(kind: @request.kind, price: @request.price, duration: @request.duration, client_id: @request.client_id, request_id: @request.id)
              @commission_created.add_process! 
            end
          end
          render json: @request, status: 200
        else
          render json: { errors: @request.errors.full_messages}, status: 422  
        end
      end

			def cancel
        @request = @current_user.requests.find(params[:id])
        if @request.status === "approved" 
          render json: { error: "unauthorized" }, status: 401   
        else
          if params[:status] != "cancelled"
            render json: { error: "unauthorized" }, status: 401
          else 
            if @request.update!(status: params[:status])
              render json: @request, status: 200
            else
              render json: { errors: @request.errors.full_messages}, status: 422   
            end
          end
        end
			end

      def update_payment
        @request = Request.where("id = ? AND artist_id = ?", params[:id], @current_user.id).first
        if @request.update!(payment_params)
          render json: @request, status: 201
        else
          render json: { errors: @request.errors.full_messages}, status: 422   
        end		
			end

			private 

			def request_params
				params.permit(:kind, :price, :duration, :artist_id)
			end

      def payment_params
				params.permit(:payment_status)
			end

      def status_params
				params.permit(:status)
			end
		end
	end
end