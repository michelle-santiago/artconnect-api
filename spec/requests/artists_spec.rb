require 'rails_helper'

RSpec.describe "artists", type: :request do

  let(:artist) { FactoryBot.create(:user, :artist) }
  let(:client) { FactoryBot.create(:user, :client) }
  let(:guest) { FactoryBot.build(:user, :client) }
  
  describe "GET /index as guest" do
    it "renders an unsuccessful response" do
      get api_v1_artists_url, headers: { Authorization: jwt_encode(guest) }
      expect(response).to have_http_status(404)
    end
  end

  describe "GET /index with invalid token" do
    it "renders a successful response" do
      get api_v1_artists_url, headers: { Authorization: "token" }
      expect(response).to have_http_status(401)
    end
  end

  describe "GET /index as an artist" do
    it "renders a successful response" do
      get api_v1_artists_url, headers: { Authorization: jwt_encode(artist) }
      print JSON.parse(response.body)
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /index as a client" do
    it "renders a successful response" do
      get api_v1_artists_url, headers: { Authorization: jwt_encode(client) }
      expect(response).to have_http_status(200)
    end
  end

end
