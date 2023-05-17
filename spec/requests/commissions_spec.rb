require 'rails_helper'

RSpec.describe "commissions", type: :request do

  let(:artist) { FactoryBot.create(:user, :artist) }
  let(:client) { FactoryBot.create(:user, :client) }
  let(:guest) { FactoryBot.build(:user, :client) }
  let(:commission) { FactoryBot.build(:commission) }
  let(:new_commission) { FactoryBot.create(:commission, price: 20, artist_id: artist.id) }
  
  describe "GET /index as guest" do
    it "renders an unsuccessful response" do
      get api_v1_commissions_url, headers: { Authorization: jwt_encode(guest) }
      expect(response).to have_http_status(404)
    end
  end

  describe "GET /index with invalid token" do
    it "renders a successful response" do
      get api_v1_commissions_url, headers: { Authorization: "token" }
      expect(response).to have_http_status(401)
    end
  end

  describe "GET /index as an artist" do
    it "renders a successful response" do
      get api_v1_commissions_url, headers: { Authorization: jwt_encode(artist) }
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /index as a client" do
    it "renders a successful response" do
      get api_v1_commissions_url, headers: { Authorization: jwt_encode(client) }
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /create as client" do
    it "renders an unauthorized response" do
      post api_v1_commissions_url, headers: { Authorization: jwt_encode(client) }, params: { kind: commission.kind, price: commission.price, duration: commission.duration }
      expect(JSON.parse(response.body)["error"]).to eq("unauthorized")
      expect(response).to have_http_status(401)
    end
  end

  describe "POST /create as an artist" do
    context "with missing parameters" do 
      it "creates a new Commission" do
        expect {
          post api_v1_commissions_url , headers: { Authorization: jwt_encode(artist) }, params: { }
        }.to change(Commission, :count).by(0)
      end
    end
  end

  describe "POST /create as an artist" do
    context "with valid parameters" do 
      it "creates a new Commission" do
        expect {
          post api_v1_commissions_url , headers: { Authorization: jwt_encode(artist) }, params: { kind: commission.kind, price: commission.price, duration: commission.duration }
        }.to change(Commission, :count).by(1)
        commission_tb = Commission.last
        expect(commission_tb.kind).to eq(commission.kind)
        expect(commission_tb.price).to eq(commission.price)
        expect(commission_tb.duration).to eq(commission.duration)
        expect(commission_tb.artist_id).to eq(artist.id)
      end
    end
  end

  describe "PATCH /update as client" do
    it "renders an unauthorized response" do
      patch "/api/v1/commissions/#{ new_commission.id }", headers: { Authorization: jwt_encode(client) }, params: { kind: commission.kind, price: commission.price, duration: commission.duration }
      expect(JSON.parse(response.body)["error"]).to eq("unauthorized")
      expect(response).to have_http_status(401)
    end
  end

    
  describe "PATCH /update as an artist" do
    context "with missing parameters" do 
      it "does not update the requested Commission" do
        patch "/api/v1/commissions/#{ new_commission.id }", headers: { Authorization: jwt_encode(artist) }, params: { kind: "", price: "", duration: ""}
        expect(response).to have_http_status(422)
      end
    end
  end

  describe "PATCH /update as an artist" do
    context "with valid parameters" do 
      it "updates the requested Commission" do
        patch "/api/v1/commissions/#{ new_commission.id }", headers: { Authorization: jwt_encode(artist) }, params: { kind: commission.kind, price: commission.price, duration: commission.duration }
        commission_tb = Commission.find(new_commission.id)
        expect(commission_tb.kind).to eq(commission.kind)
        expect(commission_tb.price).to eq(commission.price)
        expect(commission_tb.duration).to eq(commission.duration)
        expect(commission_tb.artist_id).to eq(artist.id)
      end
    end
  end

end
