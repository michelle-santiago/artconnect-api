
module Api
	module V1
		class MessagesController < ApplicationController

			def index
				if msg_params[:kind] =="commission"
					@messages = Message.where(kind: msg_params[:kind], request_id: msg_params[:request_id]).sort
				else
					@messages = @current_user.messages.where(kind: msg_params[:kind]).or(@current_user.received_messages.where(kind: msg_params[:kind], sender: msg_params[:receiver_id] ))
				end
				@receiver = User.select("id, first_name, last_name, email, username, avatar_url").find(msg_params[:receiver_id])
				render json: {messages: @messages, receiver: @receiver}, status: 200
			end

			def create
				@message = @current_user.messages.new(msg_params)
				@channel = "#{msg_params[:kind]}_channel"
				if @message.save
					print "test"
					print @message.inspect
					if msg_params[:kind] == "direct"
						@chat_id = [@message.sender_id, @message.receiver_id].sort.join
					else
						@chat_id = [@message.request_id, @message.sender_id, @message.receiver_id].sort.join
					end
					ActionCable.server.broadcast("#{@channel}#{@chat_id}", { id: @chat_id, body: @message})
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
