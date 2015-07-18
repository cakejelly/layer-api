require 'spec_helper'

describe Layer::Api::Conversations do
  before do
    @layer = Layer::Api::Client.new(
      api_token: ENV['LAYER_API_TOKEN'],
      app_id: ENV['LAYER_APP_ID']
    )
  end

  describe ".get_conversation" do
    context "when the conversation exists" do
      it "should return conversation" do
        VCR.use_cassette('conversation') do
          existing_conversation = @layer.create_conversation(conversation_params)
          existing_id = @layer.get_stripped_id(existing_conversation["id"])
          conversation = @layer.get_conversation(existing_id)

          expect(existing_conversation).to eq(conversation)
        end
      end
    end

    context "when the conversation doesn't exist" do
      it "should raise NotFound error" do
        VCR.use_cassette('conversation') do
          expect {
            conversation = @layer.get_conversation("dontexist")
          }.to raise_error(Layer::Api::NotFound)
        end
      end
    end
  end

  describe ".create_conversation" do
    it "should create and return a new conversation" do
      VCR.use_cassette('conversation') do
        conversation = @layer.create_conversation(conversation_params)

        expect(conversation["participants"]).to match_array(conversation_params[:participants])
        expect(conversation["distinct"]).to eq(conversation_params[:distinct])
        expect(conversation["metadata"].to_json).to eq(conversation_params[:metadata].to_json)
      end
    end
  end

  describe ".edit_conversation" do
    it "should edit conversation" do
      VCR.use_cassette('conversation') do
        @existing_conversation = @layer.create_conversation(conversation_params)
        @existing_conversation_id = @layer.get_stripped_id(@existing_conversation["id"])
        @existing_participants = @existing_conversation["participants"]

        @operations = [
          {operation: "add", property: "participants", value: "user1"},
          {operation: "add", property: "participants", value: "user2"}
        ]

        @layer.edit_conversation(@existing_conversation_id, @operations)
      end

      VCR.use_cassette('conversation_edited') do
        conversation = @layer.get_conversation(@existing_conversation_id)
        expected_participants_count = @existing_participants.count + @operations.count
        expect(expected_participants_count).to eq(conversation["participants"].count)
      end
    end
  end
end
