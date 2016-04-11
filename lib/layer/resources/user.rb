module Layer
  module Resources
    class User < Layer::Resource
      def self.find(client, url, id)
        new({"id" => id, "url" => "users/#{id}"}, client)
      end

      def blocks
        Layer::ResourceProxy.new(client, self, Layer::Resources::Block)
      end

      def conversations
        Layer::ResourceProxy.new(client, self, Layer::Resources::Conversation)
      end

      def messages
        Layer::ResourceProxy.new(client, self, Layer::Resources::Message)
      end

      def create_identity(params)
        client.post(identity_url,  body: params.to_json)
      end

      def identity
        client.get(identity_url)
      end

      def update_identity(params)
        client.patch(
          identity_url,
          body: params.to_json,
          headers: client.layer_patch_header
        )
      end

      def replace_identity(params)
        client.put(identity_url, body: params.to_json)
      end

      def destroy_identity
        client.delete(identity_url)
      end

      private

      def identity_url
        "#{url}/identity"
      end
    end
  end
end
