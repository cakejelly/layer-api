require 'spec_helper'

describe Layer::Api::Client do
  describe ".new" do
    it 'should allow you to set the api_token and app_id' do
      app_id = "app_id"
      api_token = "api_token"

      layer = Layer::Api::Client.new(app_id: app_id, api_token: api_token)

      expect(layer.app_id).to eq(app_id)
      expect(layer.api_token).to eq(api_token)
    end

    it 'should default to environment variables for api_token and app_id' do
      layer = Layer::Api::Client.new

      expect(layer.app_id).to eq(ENV['LAYER_APP_ID'])
      expect(layer.api_token).to eq(ENV['LAYER_API_TOKEN'])
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
