module Layer
  module Api
    module Configuration
      DEFAULT_HOST = "https://api.layer.com"

      def default_layer_headers
        {
          'Accept' => 'application/vnd.layer+json; version=1.0',
          'Authorization' => "Bearer #{api_token}",
          'Content-Type' => 'application/json'
        }
      end

      def layer_patch_header
        { 'Content-Type' => 'application/vnd.layer-patch+json' }
      end

      def base_url
        "#{DEFAULT_HOST}/apps/#{app_id}"
      end

      def connection
        connection ||= Faraday.new(url: base_url) do |faraday|
          faraday.headers = default_layer_headers
          faraday.request  :url_encoded
          faraday.adapter  Faraday.default_adapter
        end
      end
    end
  end
end
