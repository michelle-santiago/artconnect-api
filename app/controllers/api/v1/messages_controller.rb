
module Api
	module V1
		class MessagesController < ApplicationController

			def index
				if msg_params[:kind] =="commission"
					@messages = Message.where("kind = ? and ( commission_id = ? or request_id = ? ) and (sender_id = ? or receiver_id = ?)", 
					msg_params[:kind], msg_params[:commission_id], msg_params[:request_id], @current_user.id, @current_user.id)
				else
					@messages = Message.where("kind = ? and (sender_id = ? or receiver_id = ?) and (sender_id = ? or receiver_id = ?)", 
					msg_params[:kind], @current_user.id, @current_user.id, msg_params[:receiver_id], msg_params[:receiver_id])
				end
				render json: @messages, status: 200
			end

			def create
				@message = @current_user.messages.new(msg_params)
				@channel = "#{msg_params[:kind]}_channel"
				if @message.save
					if msg_params[:kind] == "direct"
						@chat_id = [@message.sender_id, @message.receiver_id].sort.join
					else
						@chat_id = [@message.request_id, @message.sender_id, @message.receiver_id].sort.join
					end
					ActionCable.server.broadcast(@channel, { id: @message.id, body: @message.body, chat_id: @chat_id })
					render json: @message, status: 201
				else 
					render json: { errors: @message.errors.full_messages}, status: 500   
				end
			end

			private

			def msg_params
				params.permit(:kind, :body, :receiver_id, :request_id, :commission_id)
			end

		end
	end
end
