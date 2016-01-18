require 'securerandom'

module Layer
  module Api
    class HttpClient
      DEFAULT_HOST = "https://api.layer.com"

      attr_reader :app_id, :api_token

      def initialize(app_id, api_token)
        @app_id = app_id
        @api_token = api_token
      end

      def connection
        @connection ||= Faraday.new(url: base_url) do |faraday|
          faraday.headers = default_layer_headers
          faraday.request  :url_encoded
          faraday.adapter  Faraday.default_adapter
          faraday.use Middleware::ApiErrors
        end
      end

      def get(url, options = {})
        call(:get, url, options)
      end

      def post(url, options = {})
        call(:post, url, options)
      end

      def patch(url, options = {})
        call(:patch, url, options)
      end

      def delete(url)
        call(:delete, url, options = {})
      end

      def call(method, url, options = {})
        response = run_request(method, url, options)
        response.body.empty? ? nil : JSON.parse(response.body)
      end

      def run_request(method, url, options = {})
        connection.run_request(
          method,
          url,
          options[:body],
          options[:headers]
        )
      end

      def default_layer_headers
        {
          'Accept' => 'application/vnd.layer+json; version=1.0',
          'Authorization' => "Bearer #{api_token}",
          'Content-Type' => 'application/json',
          'If-None-Match' => SecureRandom.uuid
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
