module Api
	module V1
		class RequestsController < ApplicationController

			before_action :authorize_client, only: [:create, :cancel]
      before_action :authorize_artist, only: [:update, :update_payment]

			def index
				render json: { welcome: "request" }, status: 201 
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
        print "banana"
        print @request.inspect
        if @request.update(status_params)
          if @request.status === "approved"
            @commission = @current_user.commissions.find_by_request_id(@request.id)
            if @commission.blank?
              @current_user.commissions.create!(kind: @request.kind, price: @request.price, duration: @request.duration, client_id: @request.client_id, request_id: @request.id, status: "in progress", phase: "sketch")
            end
          end
          render json: @request, status: 201
        else
          render json: { errors: @request.errors.full_messages}, status: 500   
        end
      end

			def cancel
        @request = @current_user.requests.find(params[:id])
        if @request.status === "approved" 
          render json: { error: "unauthorized" }, status: 401   
        else
          if status_params[:status] != "cancelled"
            render json: { error: "unauthorized" }, status: 401
          else 
            if @request.update(status_params)
              render json: @request, status: 201
            else
              render json: { errors: @request.errors.full_messages}, status: 500   
            end
          end
        end
			end

      def update_payment
        @request = @current_user.requests.find(params[:id])
        if @request.update(payment_params)
          render json: @request, status: 201
        else
          render json: { errors: @request.errors.full_messages}, status: 500   
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