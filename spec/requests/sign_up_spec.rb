require 'rails_helper'

RSpec.describe "guest", type: :request do

  let(:user) { FactoryBot.build(:user, :artist) }
 
  describe "POST /sign_up with missing params" do
    it "renders an unsuccessful response" do
      post api_v1_sign_up_url, params:  {}
      expect(response).to have_http_status(422)
    end
  end

  describe "POST /sign_up with valid params" do
    it "renders a successful response" do
      post api_v1_sign_up_url, params: { first_name: user.first_name, last_name: user.last_name, username: user.username, email: user.email, password: user.password, password_confirmation: user.password_confirmation, role: user.role }
      expect(response).to have_http_status(201)
    end
  end
  
  describe "POST /sign_up with different password/password confirmation" do
    it "renders an error response" do
      post api_v1_sign_up_url, params:  { first_name: user.first_name, last_name: user.last_name, username: user.username, email: user.email, password: user.password, password_confirmation: "different", role: user.role}
      expect(JSON.parse(response.body)["errors"]).to eq(["Password confirmation doesn't match Password"])
      expect(response).to have_http_status(422)
    end
  end

end
