
module Api
	module V1
		class HomeController < ApplicationController
			def index
				render json: { welcome: "home" }, status: 201 
			end
		end
	end
end
