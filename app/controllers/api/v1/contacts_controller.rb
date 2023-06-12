
module Api
	module V1
		class ContactsController < ApplicationController

			def index
        if @current_user.role == "artist"
          @sender_ids = @current_user.received_messages.select("sender_id").where(kind: "direct").distinct
          @contacts_ids = @sender_ids.map { |contact| contact.sender_id} 
        else
          @receiver_ids = @current_user.messages.select("receiver_id").where(kind: "direct").distinct
          @contacts_ids = @receiver_ids.map { |contact| contact.receiver_id} 
        end
        @contacts = User.select(:id, :first_name, :last_name, :email, :username, :avatar_url).where(id: @contacts_ids )
        render json: @contacts, status: 200
			end

		end
	end
end
