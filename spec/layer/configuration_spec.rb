require 'spec_helper'

describe Layer::Api::Configuration do
  describe ".default_layer_headers" do
    it "should pass api_token into Authorization header" do
      api_token = "1234"
      layer = Layer::Api::Client.new(api_token: api_token)

      expect(layer.default_layer_headers['Authorization']).to include(api_token)
    end
  end

  describe ".base_url" do
    it "should contain app_id" do
      app_id = "1234"
      layer = Layer::Api::Client.new(app_id: app_id)
      expect(layer.base_url).to include(app_id)
    end
  end
end
