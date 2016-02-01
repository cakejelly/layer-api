module Layer
  module Platform
    class Client
      attr_accessor :api_token, :app_id

      def initialize(options = {})
        @api_token = options[:api_token] || ENV['LAYER_API_TOKEN']
        @app_id = options[:app_id] || ENV['LAYER_APP_ID']
        strip_layer_prefix(@app_id)
      end

      def client
        @http_client ||= Layer::HttpClient.new(app_id, api_token)
      end

      def get(url, *args)
        client.get(url, *args)
      end

      def post(url, *args)
        client.post(url, *args)
      end

      def put(url, *args)
        client.put(url, *args)
      end

      def patch(url, *args)
        client.patch(url, *args)
      end

      def delete(url)
        client.delete(url)
      end

      def strip_layer_prefix(string)
        string.split("/").last if string
      end

      def announcements
        Layer::ResourceProxy.new(nil, Layer::Resources::Announcement)
      end

      def conversations
        Layer::ResourceProxy.new(nil, Layer::Resources::Conversation)
      end

      def users
        Layer::ResourceProxy.new(nil, Layer::Resources::User)
      end

      def get_stripped_id(raw_id)
        raw_id.sub("layer:///conversations/", "")
      end

      def generate_identity_token(options = {})
        Layer::IdentityToken.new(options).to_s
      end
    end
  end
end
