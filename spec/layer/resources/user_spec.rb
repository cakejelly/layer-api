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
    it "should instantiate new ResourceProxy" do
      user = client.users.find("jake")
      expect(user.blocks).to be_instance_of(Layer::ResourceProxy)
    end
  end

  describe "#conversations" do
    it "should instantiate new ResourceProxy" do
      user = client.users.find("jake")
      expect(user.conversations).to be_instance_of(Layer::ResourceProxy)
    end
  end
end
