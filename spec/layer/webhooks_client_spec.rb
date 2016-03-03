require "spec_helper"

describe Layer::Webhooks::Client do
  let(:client) { described_class.new }

  describe "#default_headers" do
    it "should return the correct headers needed for the Webhooks API" do
      default_headers = client.default_headers
      expected_headers = {
        "Authorization" => "Bearer #{client.api_token}",
        "Accept" => "application/vnd.layer.webhooks+json; version=1.0",
        "Content-Type" => "application/json"
      }

      expect(default_headers).to eq(expected_headers)
    end
  end

  describe "#base_url" do
    it "should return the correct base API URL" do
      expected_url = "https://api.layer.com/apps/#{client.app_id}"

      expect(client.base_url).to eq(expected_url)
    end
  end

  describe "#webhooks" do
    it "should return a ResourceProxy" do
      webhooks = client.webhooks
      resource = webhooks.instance_variable_get("@resource")

      expect(webhooks).to be_instance_of(Layer::ResourceProxy)
      expect(resource).to eq(Layer::Resources::Webhook)
    end
  end
end
