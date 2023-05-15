module Api
	module V1
		class ArtistController < ApplicationController
			def index
				@artists = Users.where(role: 'artist')
				render json: { data: @artists.username }, status: 200
			end
		end
	end
end
