module Api
	module V1
		class ArtistsController < ApplicationController
			def index
				@artists = User.where(role: 'artist').select("id, first_name, last_name, email, username, about, max_slot, terms, avatar_url")
				
				render json: @artists, status: 200
			end
		end
	end
end
