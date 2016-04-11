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
        client.post("#{url}/identity",  body: params.to_json)
      end

      def identity
        client.get("#{url}/identity")
      end
    end
  end
end
