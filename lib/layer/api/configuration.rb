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
    end
  end
end
