require 'spec_helper'

describe Layer::Resources::Conversation do
  let(:client) { Layer::Platform::Client.new }

  describe ".create" do
    context "with valid params" do
      it "should create a conversation" do
        VCR.use_cassette("conversation") do
          conversation = client.conversations.create(conversation_params)

          expect(conversation.id).to_not be_nil
          expect(conversation.url).to_not be_nil
          expect(conversation.created_at).to_not be_nil
          expect(conversation.participants).to match_array(conversation_params[:participants])
        end
      end

      it "should instantiate a Conversation" do
        VCR.use_cassette("conversation") do
          conversation = client.conversations.create(conversation_params)

          expect(conversation).to be_instance_of(described_class)
        end
      end
    end

    context "with invalid params" do
      it "should raise Layer::Error" do
        VCR.use_cassette("conversation_error") do
          expect{client.conversations.create}.to raise_error(Layer::Error)
        end
      end
    end
  end

  describe ".find" do
    context "when conversation exists" do
      it "should return the conversation" do
        VCR.use_cassette('conversation') do
          existing_conversation = client.conversations.create(conversation_params)
          existing_id = client.get_stripped_id(existing_conversation.id)
          conversation = client.conversations.find(existing_id)

          expect(existing_conversation.id).to eq(conversation.id)
        end
      end

      it "should instantiate a Conversation" do
        VCR.use_cassette("conversation") do
          existing_conversation = client.conversations.create(conversation_params)
          existing_id = client.get_stripped_id(existing_conversation.id)
          conversation = client.conversations.find(existing_id)

          expect(conversation).to be_instance_of(described_class)
        end
      end
    end
  end

  describe "#update" do
    it "should update conversation" do
      VCR.use_cassette('conversation') do
        existing_conversation = client.conversations.create(conversation_params)
        existing_conversation_id = client.get_stripped_id(existing_conversation.id)
        existing_participants = existing_conversation.participants

        operations = [
          {operation: "add", property: "participants", value: "user1"},
          {operation: "add", property: "participants", value: "user2"}
        ]

        existing_conversation.update(operations)

        VCR.use_cassette('conversation_edited', exclusive: true) do
          conversation = client.conversations.find(existing_conversation_id)
          expected_participants_count = existing_participants.count + operations.count
          expect(expected_participants_count).to eq(conversation.participants.count)
        end
      end
    end
  end

  describe "#destroy" do
    it "should remove conversation" do
      VCR.use_cassette("conversation") do
        conversation = client.conversations.create(conversation_params)
        conversation.destroy

        VCR.use_cassette("conversation_destroyed", exclusive: true) do
          expect {
            removed_conv = client.conversations.find(client.strip_layer_prefix(conversation.id))
          }.to raise_error(Layer::Error)
        end
      end
    end
  end

  describe "#messages" do
    it "should instantiate new ResourceProxy" do
      VCR.use_cassette("conversation") do
        conversation = client.conversations.create(conversation_params)

        expect(conversation.messages).to be_instance_of(Layer::ResourceProxy)
      end
    end
  end
end
