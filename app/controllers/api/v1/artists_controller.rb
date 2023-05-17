module Api
	module V1
		class ArtistsController < ApplicationController
			def index
				@artists = User.where(role: 'artist').select("id,username")
				render json: @artists, status: 200
			end
		end
	end
end
