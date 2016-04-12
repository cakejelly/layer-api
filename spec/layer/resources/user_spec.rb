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

  describe "#update_identity" do
    let(:patch_header) { { 'Content-Type' => 'application/vnd.layer-patch+json' } }

    it "should update the users identity" do
      allow(http_client).to receive(:patch).and_return("")
      allow(http_client).to receive(:layer_patch_header).and_return(patch_header)

      expect(http_client).to receive(:patch).
                              with(
                                "users/#{user.id}/identity",
                                body: user_identity_operations.to_json,
                                headers: patch_header
                              )

      user.update_identity(user_identity_operations)
    end
  end

  describe "#replace_identity" do
    it "should replace the users identity" do
      allow(http_client).to receive(:put).and_return("")
      expect(http_client).to receive(:put).
                              with(
                                "users/#{user.id}/identity",
                                body: user_identity_params.to_json
                              )

      user.replace_identity(user_identity_params)
    end
  end

  describe "#delete_identity" do
    it "should make a request to delete the users identity" do
      allow(http_client).to receive(:delete).and_return("")
      expect(http_client).to receive(:delete).with("users/#{user.id}/identity")

      user.destroy_identity
    end
  end

  describe "#set_badge" do
    let(:badge_count) { { external_unread_count: 5 } }

    it "should set the badge count for a user" do
      allow(http_client).to receive(:put).and_return(nil)
      expect(http_client).to receive(:put).with(
                               "users/#{user.id}/badge",
                               body: badge_count.to_json
                             )
      user.set_badge(5)
    end
  end

  describe "#badge" do
    before do
      allow(http_client).to receive(:get).and_return(user_badge)
      expect(http_client).to receive(:get).with("users/#{user.id}/badge")
    end

    it "should retrieve badge for a user" do
      user.badge
    end

    it "should return hash of badge values" do
      expect(user.badge).to be_instance_of(Hash)
    end
  end
end
