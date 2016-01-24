require 'spec_helper'

describe Layer::Resources::Block do
  let(:client) { Layer::Api::Client.new }

  describe ".create" do
    it "should add new blocked user to the owners block list" do
      VCR.use_cassette("block") do
        owner = client.users.find("owner")

        block = owner.blocks.create(user_id: "block")

        expect(block.url).to_not be_nil
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
      it "should raise Layer::Api::Error" do
        VCR.use_cassette("block_error") do
          owner = client.users.find("owner")

          expect {
            owner.blocks.create
          }.to raise_error(Layer::Api::Error)
        end
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
