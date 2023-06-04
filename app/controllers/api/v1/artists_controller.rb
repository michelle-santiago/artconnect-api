module Api
	module V1
		class ArtistsController < ApplicationController
			def index
				@artists = User.where(role: 'artist').select("id, first_name, last_name, email, username, about, max_slot, terms, avatar_url")
				
				render json: @artists, status: 200
			end

			def show
				@artist = User.select("id, first_name, last_name, email, username, about, max_slot, terms, avatar_url").find_by_username(params[:id])
				
				render json: @artist, status: 200
			end

			def update

			end
		end
	end
end
