require 'spec_helper'

describe Layer::Resources::Message do
  let(:client) { Layer::Platform::Client.new }

  describe ".create" do
    it "should send a message to a conversation" do
      VCR.use_cassette("conversation") do
        conversation = client.conversations.create(conversation_params)
        message = conversation.messages.create(message_params)

        expect(message.id).to_not be_nil
        expect(message.url).to_not be_nil
        expect(message.sent_at).to_not be_nil
      end
    end

    it "should instantiate a Message" do
      VCR.use_cassette("conversation") do
        conversation = client.conversations.create(conversation_params)
        message = conversation.messages.create(message_params)

        expect(message).to be_instance_of(described_class)
      end
    end

    context "with invalid params" do
      it "should raise Layer::Error" do
        VCR.use_cassette("conversation") do
          conversation = client.conversations.create(conversation_params)

          VCR.use_cassette("message_error", exclusive: true) do
            expect{
              conversation.messages.create
            }.to raise_error(Layer::Error)
          end
        end
      end
    end
  end

  describe ".list" do
    context "for a conversation" do
      it "should return all messages for that conversation" do
        VCR.use_cassette("conversation_messages") do
          conversation = client.conversations.create(conversation_params)

          VCR.use_cassette("messages", exclusive: true) do
            3.times { conversation.messages.create(message_params) }

            messages = conversation.messages.list
            expect(messages.count).to eq(3)
          end
        end
      end

      it "should return a collection of Message objects" do
        VCR.use_cassette("conversation_messages") do
          conversation = client.conversations.create(conversation_params)

          VCR.use_cassette("messages", exclusive: true) do
            3.times { conversation.messages.create(message_params) }

            messages = conversation.messages.list

            messages.each do |msg|
              expect(msg).to be_instance_of(described_class)
              expect(msg.conversation["id"]).to eq(conversation.id)
            end
          end
        end
      end
    end
  end

  describe ".find" do
    context "in a conversation" do
      it "should return message" do
        VCR.use_cassette("conversation_find") do
          conv = client.conversations.create(conversation_params)

          VCR.use_cassette("messages", exclusive: true) do
            existing_msg = conv.messages.create(message_params)
            msg = conv.messages.find(client.strip_layer_prefix(existing_msg.id))

            expect(msg).to_not be_nil
            expect(msg).to be_instance_of(described_class)
            expect(msg.conversation["id"]).to eq(conv.id)
          end
        end
      end
    end
  end
end
