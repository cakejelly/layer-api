module Layer
  module Resources
    class Conversation < Layer::Resource
      def messages
        Layer::ResourceProxy.new(client, self, Message)
      end

      def content
        proxy = Layer::ResourceProxy.new(client, self, RichContent)
        proxy.url = content_url
        proxy
      end

      def content_url
        "conversations/#{uuid}/content"
      end
    end
  end
end
