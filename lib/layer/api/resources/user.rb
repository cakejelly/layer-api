module Layer
  module Resources
    class User < Layer::Api::Resource
      def self.find(url, id)
        new({"url" => "users/#{id}"})
      end

      def blocks
        Layer::Api::ResourceProxy.new(self, Layer::Resources::Block)
      end

      def conversations
        Layer::Api::ResourceProxy.new(self, Layer::Resources::Conversation)
      end
    end
  end
end
