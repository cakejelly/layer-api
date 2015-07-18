module Layer
  module Api
    module Conversations
      def get_conversation(conversation_id)
        response = connection.get("conversations/#{conversation_id}")
        JSON.parse(response.body)
      end

      def create_conversation(params = {})
        response = connection.post("conversations", params.to_json)
        JSON.parse(response.body)
      end

      def edit_conversation(conversation_id, params = {})
        connection.patch("conversations/#{conversation_id}",
          params.to_json,
          layer_patch_header
        )
      end
    end
  end
end
