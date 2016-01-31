module Layer
  module Resources
    class User < Layer::Resource
      def self.find(url, id)
        new({"url" => "users/#{id}"})
      end

      def blocks
        Layer::ResourceProxy.new(self, Layer::Resources::Block)
      end

      def conversations
        Layer::ResourceProxy.new(self, Layer::Resources::Conversation)
      end
    end
  end
end
