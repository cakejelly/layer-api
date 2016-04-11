require 'spec_helper'

describe Layer::Resources::User do
  let(:client) { Layer::Platform::Client.new }
  let(:http_client) { instance_double("Layer::HttpClient") }
  let(:user) { client.users.find("some_user") }

  before do
    allow(client).to receive(:client).and_return(http_client)
  end

  describe ".find" do
    it "should return instance of User" do
      expect(user).to be_instance_of(described_class)
    end

    it "shouldn't send any request" do
      expect(Layer::HttpClient).to_not receive(:find)
      user
    end
  end

  describe "#blocks" do
    it "should instantiate new ResourceProxy for Block" do
      blocks = user.blocks
      base = blocks.instance_variable_get("@base")
      resource = blocks.instance_variable_get("@resource")

      expect(blocks).to be_instance_of(Layer::ResourceProxy)
      expect(base).to be_instance_of(described_class)
      expect(resource).to eq(Layer::Resources::Block)
    end
  end

  describe "#conversations" do
    it "should instantiate new ResourceProxy for Conversation" do
      conversations = user.conversations
      base = conversations.instance_variable_get("@base")
      resource = conversations.instance_variable_get("@resource")

      expect(conversations).to be_instance_of(Layer::ResourceProxy)
      expect(base).to be_instance_of(described_class)
      expect(resource).to eq(Layer::Resources::Conversation)
    end
  end

  describe "#messages" do
    it "should instantiate new ResourceProxy for Message" do
      messages = user.messages
      base = messages.instance_variable_get("@base")
      resource = messages.instance_variable_get("@resource")

      expect(messages).to be_instance_of(Layer::ResourceProxy)
      expect(base).to be_instance_of(described_class)
      expect(resource).to eq(Layer::Resources::Message)
    end
  end

  describe "#create_identity" do
    it "should create identity for a user" do
      allow(http_client).to receive(:post).and_return("")
      expect(http_client).to receive(:post).
                              with("users/#{user.id}/identity", body: user_identity_params.to_json)

      user.create_identity(user_identity_params)
    end
  end

  describe "#identity" do
    before do
      allow(http_client).to receive(:get).and_return(user_identity_params)
      expect(http_client).to receive(:get).with("users/#{user.id}/identity")
    end

    it "should retrieve the users identity" do
      user.identity
    end

    it "should return a hash containing the users identity" do
      identity = user.identity
      expect(identity).to be_instance_of(Hash)
    end
  end
end
