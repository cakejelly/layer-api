require 'spec_helper'

describe Layer::Resources::Block do
  let(:client) { Layer::Platform::Client.new }

  describe ".create" do
    it "should add new blocked user to the owners block list" do
      VCR.use_cassette("block") do
        owner = client.users.find("tester")

        expect {
          block = owner.blocks.create(user_id: "block")
          expect(block.url).to_not be_nil
        }.to change{owner.blocks.list.count}.by(1)
      end
    end

    it "should instantiate a new Block object" do
      VCR.use_cassette("block") do
        owner = client.users.find("owner")

        block = owner.blocks.create(user_id: "block")

        expect(block).to be_instance_of(described_class)
      end
    end

    context "with invalid params" do
      it "should raise Layer::Error" do
        VCR.use_cassette("block_error") do
          owner = client.users.find("owner")

          expect {
            owner.blocks.create
          }.to raise_error(Layer::Error)
        end
      end
    end

    context "when passing in a User object" do
      it "should add this user to the owners block list" do
        VCR.use_cassette("block_user") do
          owner = client.users.find("tester2")
          user = client.users.find("jake")

          expect {
            block = owner.blocks.create(user)
            expect(block.url).to_not be_nil
          }.to change{owner.blocks.list.count}.by(1)
        end
      end
    end
  end

  describe ".find" do
    it "should return instance of Block" do
      user = client.users.find("user")
      block = user.blocks.find("blocked")

      expect(block).to be_instance_of(described_class)
    end

    it "shouldn't send any request" do
      user = client.users.find("user")

      expect(Layer::HttpClient).to_not receive(:find)
      user.blocks.find("blah")
    end

    context "when User object passed as param" do
      it "should use the users id attribute when building instance url" do
        owner = client.users.find("owner")
        user = client.users.find("user")

        block = owner.blocks.find(user)

        expect(block).to be_instance_of(described_class)
        expect(block.url).to eq("users/#{owner.id}/blocks/#{user.id}")
      end
    end
  end

  describe ".list" do
    it "should return block list for a user" do
      VCR.use_cassette("blocks") do
        owner = client.users.find("blocks")
        3.times{ |n| owner.blocks.create(user_id: "block#{n}") }

        block_list = owner.blocks.list

        expect(block_list.count).to eq(3)
      end
    end

    it "should return collection of Block objects" do
      VCR.use_cassette("blocks") do
        owner = client.users.find("blocks")
        block_list = owner.blocks.list

        expect(block_list).to be_instance_of(Array)
        block_list.each do |block|
          expect(block).to be_instance_of(described_class)
        end
      end
    end
  end

  describe "#destroy" do
    it "should remove blocked user from owners block list" do
      VCR.use_cassette("blocks") do
        owner = client.users.find("blocks_delete")

        block = owner.blocks.create(user_id: "newblock")
        block.destroy

        block_list = owner.blocks.list
        expect(block_list.count).to eq(0)
      end
    end
  end
end
