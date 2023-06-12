require 'rails_helper'

RSpec.describe "requests", type: :request do

  let(:artist) { FactoryBot.create(:user, :artist) }
  let(:client) { FactoryBot.create(:user, :client) }
  let(:guest) { FactoryBot.build(:user, :client) }
  let(:request) { FactoryBot.build(:request, artist_id: artist.id) }
  let(:new_request) { FactoryBot.create(:request, client_id: client.id, artist_id: artist.id) }
  let(:approved_request) { FactoryBot.create(:request, status: "approved", client_id: client.id, artist_id: artist.id) }

  describe "GET /index as guest" do
    it "renders an unsuccessful response" do
      get api_v1_requests_url, headers: { Authorization: jwt_encode(guest) }
      expect(response).to have_http_status(404)
    end
  end

  describe "GET /index with invalid token" do
    it "renders a successful response" do
      get api_v1_requests_url, headers: { Authorization: "token" }
      expect(response).to have_http_status(401)
    end
  end

  describe "GET /index as client" do
    it "renders a successful response" do
      get api_v1_requests_url, headers: { Authorization: jwt_encode(client) }
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /index as artist" do
    it "renders a successful response" do
      get api_v1_requests_url, headers: { Authorization: jwt_encode(artist) }
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /create as artist" do
      it "renders an unauthorized response" do
        post api_v1_requests_url, headers: { Authorization: jwt_encode(artist) }, params: { kind: request.kind, price: request.price, duration: request.duration }
        expect(JSON.parse(response.body)["error"]).to eq("unauthorized")
        expect(response).to have_http_status(401)
      end
  end

  describe "POST /create as a client" do
    context "with missing parameters" do 
      it "creates a new Request" do
        expect {
          post api_v1_requests_url , headers: { Authorization: jwt_encode(client) }, params: { }
        }.to change(Request, :count).by(0)
      end
    end
  end

  describe "POST /create as client" do
    context "with valid parameters" do 
      it "creates a new Request" do
        expect {
          post api_v1_requests_url , headers: { Authorization: jwt_encode(client) }, params: { kind: request.kind, price: request.price, duration: request.duration, artist_id: artist.id }
        }.to change(Request, :count).by(1)
        request_tb = Request.last
        expect(request_tb.kind).to eq(request.kind)
        expect(request_tb.price).to eq(request.price)
        expect(request_tb.duration).to eq(request.duration)
      end
    end
  end
  
  describe "PATCH /update status as client" do
    it "renders an unauthorized response" do
      patch "/api/v1/requests/#{ new_request.id }?status=", headers: { Authorization: jwt_encode(client) }
      expect(JSON.parse(response.body)["error"]).to eq("unauthorized")
      expect(response).to have_http_status(401)
    end
  end

  describe "PATCH /update status as artist" do
    context "with missing parameters" do 
      it "does not update Request" do
        patch "/api/v1/requests/#{ new_request.id }?status=null", headers: { Authorization: jwt_encode(artist) }
        expect(response).to have_http_status(422)
      end
    end
  end

  describe "PATCH /update status as an artist" do
    context "with valid parameters" do 
      it "updates request and creates a new Commission" do
        expect {
          patch "/api/v1/requests/#{ new_request.id }?status=approved", headers: { Authorization: jwt_encode(artist) }
        }.to change(Commission, :count).by(1)
        commission_tb = Commission.last
        expect(commission_tb.kind).to eq(new_request.kind)
        expect(commission_tb.price).to eq(new_request.price)
        expect(commission_tb.duration).to eq(new_request.duration)
        expect(commission_tb.client_id).to eq(new_request.client_id)
      end
    end
  end

  describe "PATCH /update/:payment_status as client" do
    it "renders an unauthorized response" do
      patch "/api/v1/requests/#{ new_request.id }/paid", headers: { Authorization: jwt_encode(client) }
      expect(JSON.parse(response.body)["error"]).to eq("unauthorized")
      expect(response).to have_http_status(401)
    end
  end
  
  describe "PATCH /update/:payment_status as an artist" do
    context "with valid parameters" do 
      it "updates the Request" do
        patch "/api/v1/requests/#{ new_request.id }/paid", headers: { Authorization: jwt_encode(artist) }
        request_tb = Request.find(new_request.id)
        expect(request_tb.payment_status).to eq("paid")
      end
    end
  end

  describe "PATCH /update status as artist" do
    it "renders an unauthorized response" do
      patch "/api/v1/requests/#{ new_request.id }/cancelled/client", headers: { Authorization: jwt_encode(artist) }
      expect(JSON.parse(response.body)["error"]).to eq("unauthorized")
      expect(response).to have_http_status(401)
    end
  end

  describe "PATCH /cancel as an client" do
    context "with valid parameters" do 
      it "cancels the Request" do
        patch "/api/v1/requests/#{ new_request.id }/cancelled/edit", headers: { Authorization: jwt_encode(client) }
        request_tb = Request.find(new_request.id)
        request_tb.reload
        expect(request_tb.status).to eq("cancelled")
      end
    end
  end

  describe "PATCH /cancel as an client" do
    context "with approved status" do 
      it "does not cancel the Request" do
        patch "/api/v1/requests/#{ approved_request.id }/cancelled/edit", headers: { Authorization: jwt_encode(client) }
        expect(JSON.parse(response.body)["error"]).to eq("unauthorized")
        expect(response).to have_http_status(401)
      end
    end
  end

  describe "PATCH /cancel as an client" do
    context "with status other than cancelled" do 
      it "does not cancel the Request" do
        patch "/api/v1/requests/#{ new_request.id }/approved/edit", headers: { Authorization: jwt_encode(client) }
        expect(JSON.parse(response.body)["error"]).to eq("unauthorized")
        expect(response).to have_http_status(401)
      end
    end
  end
end
