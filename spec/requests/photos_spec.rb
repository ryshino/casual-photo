require 'rails_helper'

RSpec.describe "Photos", type: :request do
  describe "#index" do
    it "正常にレスポンスを返すこと" do
      get photos_path
      expect(response).to be_success
      expect(response).to have_http_status "200"
    end
  end
end
