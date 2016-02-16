module Layer
  module Resources
    class Conversation < Layer::Resource
      def messages
        Layer::ResourceProxy.new(client, self, Message)
      end
    end
  end
end
