require 'spec_helper'

describe Layer::Resources::Webhook do
  let(:client) { Layer::Webhooks::Client.new }

  describe ".create" do
    it "should create a new Webhook" do
      VCR.use_cassette("webhook_create") do
        expect(client.client).to receive(:post)

        client.webhooks.create(webhook_params)
      end
    end

    it "should instantiate a Webhook" do
      VCR.use_cassette("webhook_create") do
        webhook = client.webhooks.create(webhook_params)

        expect(webhook).to be_instance_of(described_class)
      end
    end

    it "should raise Layer::Error with invalid params" do
      VCR.use_cassette("webhook_error") do
        expect {
          client.webhooks.create
        }.to raise_error(Layer::Error)
      end
    end
  end

  describe ".list" do
    it "should return a collection of Webhooks" do
      VCR.use_cassette("webhook_list") do
        3.times { client.webhooks.create(webhook_params) }

        webhooks = client.webhooks.list

        webhooks.each{|webhook| expect(webhook).to be_instance_of(described_class)}
      end
    end
  end

  describe ".find" do
    it "should return a Webhook" do
      VCR.use_cassette("webhook_create") do
        existing_webhook = client.webhooks.create(webhook_params)

        VCR.use_cassette("webhook_find", exclusive: true) do
          webhook = client.webhooks.find(existing_webhook.uuid)

          expect(webhook.id).to eq(existing_webhook.id)
          expect(webhook).to be_instance_of(described_class)
        end
      end
    end
  end
end
