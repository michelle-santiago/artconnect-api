require 'rails_helper'

RSpec.describe "messages", type: :request do

  let(:artist) { FactoryBot.create(:user, :artist) }
  let(:client) { FactoryBot.create(:user, :client) }
  let(:guest) { FactoryBot.build(:user, :client) }
  let(:request) { FactoryBot.create(:request, artist_id: artist.id, client_id: client.id) }
  let(:commission) { FactoryBot.create(:commission, request_id: request.id, artist_id: artist.id, client_id: client.id) }
  
  describe "GET /index as guest" do
    it "renders an unsuccessful response" do
      get api_v1_messages_url, headers: { Authorization: jwt_encode(guest) }
      expect(response).to have_http_status(404)
    end
  end

  describe "GET /index with invalid token" do
    it "renders a successful response" do
      get api_v1_messages_url, headers: { Authorization: "token" }
      expect(response).to have_http_status(401)
    end
  end

  describe "GET commission message /index as an artist" do
    it "renders a successful response" do
      get "/api/v1/messages?kind=commission&receiver_id=#{ client.id}&request_id=#{request.id }&commission_id=#{ commission.id }", headers: { Authorization: jwt_encode(artist) }
      expect(response).to have_http_status(200)
    end
  end

  describe "GET direct message /index as an artist" do
    it "renders a successful response" do
      get "/api/v1/messages?kind=direct&receiver_id=#{ client.id}", headers: { Authorization: jwt_encode(artist) }
      expect(response).to have_http_status(200)
    end
  end

  describe "GET commission message /index as an client" do
    it "renders a successful response" do
      get "/api/v1/messages?kind=commission&receiver_id=#{ client.id}&request_id=#{request.id }&commission_id=#{ commission.id }", headers: { Authorization: jwt_encode(client) }
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /create commission msg  as an artist" do
    context "with valid parameters" do 
      it "creates a new messages" do
        expect {
          post api_v1_messages_url, headers: { Authorization: jwt_encode(artist) }, params: { kind: "commission", receiver_id: client.id, request_id: request.id, commission_id: commission.id, body: "hello" }
        }.to change(Message, :count).by(1)
        message_tb = Message.last
        expect(message_tb.body).to eq("hello")
      end
    end
  end

  describe "POST /create direct msg  as an artist" do
    context "with valid parameters" do 
      it "creates a new messages" do
        expect {
          post api_v1_messages_url, headers: { Authorization: jwt_encode(artist) }, params: { kind: "direct", receiver_id: client.id, body: "hello" }
        }.to change(Message, :count).by(1)
        message_tb = Message.last
        expect(message_tb.body).to eq("hello")
      end
    end
  end
end
