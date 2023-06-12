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
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /index as a client" do
    it "renders a successful response" do
      get api_v1_artists_url, headers: { Authorization: jwt_encode(client) }
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /show artist" do
    it "renders a successful response" do
      get "/api/v1/artists/#{artist.id }", headers: { Authorization: jwt_encode(client) }
      expect(response).to have_http_status(200)
    end
  end

  describe "PATCH /update about as an artist" do
    context "with valid parameters" do 
      it "renders a successful response" do
        patch "/api/v1/about", headers: { Authorization: jwt_encode(artist) }, params: { about: "my about"}
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "PATCH /update terms as an artist" do
    context "with valid parameters" do 
      it "renders a successful response" do
        patch "/api/v1/terms", headers: { Authorization: jwt_encode(artist) }, params: { about: "my terms"}
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "PATCH /update max_slot as an artist" do
    context "with valid parameters" do 
      it "renders a successful response" do
        patch "/api/v1/max_slot", headers: { Authorization: jwt_encode(artist) }, params: { about: "my slots"}
        expect(response).to have_http_status(200)
      end
    end
  end

end
