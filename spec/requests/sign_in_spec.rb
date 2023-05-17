require 'rails_helper'

RSpec.describe "user", type: :request do

  let(:user) { FactoryBot.create(:user, :artist) }

  describe "POST /sign_in with missing params" do
    it "renders unsuccessful response" do
      post api_v1_sign_in_url, params: { email: "", password: "" }
      expect(JSON.parse(response.body)["error"]).to eq("Fields can't be blank")
      expect(response).to have_http_status(422)
    end
  end

  describe "POST /sign_in with valid params" do
    it "renders a successful response" do
      post api_v1_sign_in_url, params: { email: user.email, password: user.password }
      expect(response).to have_http_status(200)
    end
  end
  
  describe "POST /sign_in with invalid params" do
    it "renders an error response" do
      post api_v1_sign_in_url, params: { email: user.email, password: "wrong"}
      expect(JSON.parse(response.body)["error"]).to eq("Invalid email/password credentials")
      expect(response).to have_http_status(401)
    end
  end

end
