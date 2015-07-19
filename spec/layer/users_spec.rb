require 'spec_helper'

describe Layer::Api::Users do
  before do
    @layer = Layer::Api::Client.new(
      api_token: ENV['LAYER_API_TOKEN'],
      app_id: ENV['LAYER_APP_ID']
    )
  end

  describe ".get_blocklist" do
    it "should return a users blocklist" do
      VCR.use_cassette('user') do
        blocklist = @layer.get_blocklist("testuser")
        expect(blocklist).to be_instance_of(Array)
      end
    end
  end

  describe ".block_user" do
    it "should add a user to another users blocklist" do
      VCR.use_cassette('user') do
        test_user = "test"
        blocked_user = "blocked"
        @layer.block_user(test_user, blocked_user)

        blocklist = @layer.get_blocklist(test_user)
        expect(blocklist).to include({"user_id" => blocked_user})
      end
    end
  end

  describe ".unblock_user" do
    it "should remove a user from another users blocklist" do
      VCR.use_cassette('user') do
        test_user = "testdelete"
        blocked_user = "newblocked"

        @layer.block_user(test_user, blocked_user)
        @layer.unblock_user(test_user, blocked_user)
        blocklist = @layer.get_blocklist(test_user)

        expect(blocklist).to eq([])
      end
    end
  end
end
