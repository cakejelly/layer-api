module Layer
  module Platform
    class Client
      attr_accessor :api_token, :app_id

      def initialize(options = {})
        id = options[:app_id] || ENV['LAYER_APP_ID']
        @api_token = options[:api_token] || ENV['LAYER_API_TOKEN']
        @app_id = strip_layer_prefix(id)
      end

      def client
        @http_client ||= Layer::HttpClient.new(@app_id, @api_token)
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
        Layer::ResourceProxy.new(client, nil, Layer::Resources::Announcement)
      end

      def conversations
        Layer::ResourceProxy.new(client, nil, Layer::Resources::Conversation)
      end

      def users
        Layer::ResourceProxy.new(client, nil, Layer::Resources::User)
      end

      def generate_identity_token(options = {})
        Layer::IdentityToken.new(options)
      end
    end
  end
end
