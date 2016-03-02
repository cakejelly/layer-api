module Layer
  module Resources
    class Message < Layer::Resource
      def destroy
        client.delete(delete_url)
      end

      private

      def delete_url
        conversation_url = conversation["id"].split("layer:///").last

        "#{conversation_url}/messages/#{uuid}"
      end
    end
  end
end
