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

  describe ".strip_layer_prefix" do
    it "should remove layer prefixes from a string" do
      layer = Layer::Api::Client.new
      app_id = "app_id"

      layer_prefixed_string = "layer:///apps/staging/#{app_id}"
      stripped_id = layer.strip_layer_prefix(layer_prefixed_string)

      expect(stripped_id).to eq(app_id)
    end

    it "should return original string if there's no layer prefix" do
      layer = Layer::Api::Client.new
      app_id = "app_id"
      stripped_id = layer.strip_layer_prefix(app_id)
      expect(stripped_id).to eq(app_id)
    end
  end
end
