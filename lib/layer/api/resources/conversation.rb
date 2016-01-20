module Layer
  module Resources
    class Conversation < Layer::Api::Resource
      def messages
        Layer::Api::ResourceProxy.new(self, Message)
      end
    end
  end
end
