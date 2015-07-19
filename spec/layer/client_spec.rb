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
end
