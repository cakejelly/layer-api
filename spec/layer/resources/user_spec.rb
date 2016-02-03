require 'spec_helper'

describe Layer::Resources::User do
  let(:client) { Layer::Platform::Client.new }

  describe ".find" do
    it "should return instance of User" do
      user = client.users.find("jake")
      expect(user).to be_instance_of(described_class)
    end

    it "shouldn't send any request" do
      expect(Layer::HttpClient).to_not receive(:find)
      client.users.find("jake")
    end
  end

  describe "#blocks" do
    it "should instantiate new ResourceProxy for Block" do
      user = client.users.find("jake")
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
      user = client.users.find("jake")
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
      user = client.users.find("jake")
      messages = user.messages
      base = messages.instance_variable_get("@base")
      resource = messages.instance_variable_get("@resource")

      expect(messages).to be_instance_of(Layer::ResourceProxy)
      expect(base).to be_instance_of(described_class)
      expect(resource).to eq(Layer::Resources::Message)
    end
  end
end
