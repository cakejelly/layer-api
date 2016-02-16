module Layer
  module Resources
    class User < Layer::Resource
      def self.find(client, url, id)
        new({"id" => id, "url" => "users/#{id}"})
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
    end
  end
end
