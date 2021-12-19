require 'rails_helper'

RSpec.describe "Admins", type: :request do
  # before do
  #   # current_api_v1_user.user_type == 'admin'
  #   sign_in create(:admin)
  # end

  describe "GET /index" do
    # pending "add some examples (or delete) #{__FILE__}"
     it "returns the list of traders" do
        get api_v1_admins_path

        expect(response).to have_http_status(:success)
        # headers = { "ACCEPT" => "application/json" }
        # post "/widgets", :params => { :widget => {:name => "My Widget"} }, :headers => headers

        # expect(response.content_type).to eq("application/json")

     end
  end
end
