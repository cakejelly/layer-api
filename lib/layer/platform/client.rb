module Layer
  module Platform
    class Client < Layer::BaseClient
      attr_accessor :api_token, :app_id

      def initialize(options = {})
        id = options[:app_id] || ENV['LAYER_APP_ID']
        @api_token = options[:api_token] || ENV['LAYER_API_TOKEN']
        @app_id = strip_layer_prefix(id)
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

      def default_headers
        super.merge({"Authorization" => "Bearer #{api_token}"})
      end

      def base_url
        "#{DEFAULT_HOST}/apps/#{app_id}"
      end

      def inspect
        "#<#{self.class} api_token=\"#{@api_token}\" app_id=\"#{@app_id}\">"
      end

      alias_method :to_s, :inspect
    end
  end
end
