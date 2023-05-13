class HomeController < ApplicationController
    def index
        render json: { welcome: "home" }, status: 201 
    end
end
