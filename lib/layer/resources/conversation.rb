module Layer
  module Resources
    class Conversation < Layer::Resource
      def messages
        Layer::ResourceProxy.new(self, Message)
      end
    end
  end
end
