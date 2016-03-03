module Layer
  module Webhooks
    class Client < Layer::BaseClient
      attr_accessor :api_token, :app_id

      def initialize(options = {})
        id = options[:app_id] || ENV['LAYER_APP_ID']
        @api_token = options[:api_token] || ENV['LAYER_API_TOKEN']
        @app_id = strip_layer_prefix(id)
      end

      def webhooks
        Layer::ResourceProxy.new(client, nil, Layer::Resources::Webhook)
      end

      def default_headers
        super.merge(
          {
            "Authorization" => "Bearer #{api_token}",
            "Accept" => "application/vnd.layer.webhooks+json; version=1.0"
          }
        )
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
