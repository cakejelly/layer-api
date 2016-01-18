module Layer
  module Api
    module Conversations
      def get_conversation(conversation_id)
        get("conversations/#{conversation_id}")
      end

      def create_conversation(params = {})
        post("conversations", body: params.to_json)
      end

      def edit_conversation(conversation_id, params = {})
        patch("conversations/#{conversation_id}",
          body: params.to_json,
          headers: client.layer_patch_header
        )
      end

      def send_message(conversation_id, message = {})
        post("conversations/#{conversation_id}/messages",
          body: message.to_json
        )
      end

      def get_stripped_id(raw_id)
        raw_id.sub("layer:///conversations/", "")
      end
    end
  end
end
