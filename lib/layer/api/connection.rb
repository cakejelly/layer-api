module Layer
  module Api
    module Connection
      def connection
        connection ||= Faraday.new(url: base_url) do |faraday|
          faraday.headers = default_layer_headers
          faraday.request  :url_encoded
          faraday.adapter  Faraday.default_adapter
        end
      end

      def get(url, options = {})
        run_request(:get, url, options)
      end

      def post(url, options = {})
        run_request(:post, url, options)
      end

      def patch(url, options = {})
        run_request(:patch, url, options)
      end

      def delete(url)
        run_request(:delete, url, options = {})
      end

      def run_request(method, url, options = {})
        response = connection.run_request(
          method,
          url,
          options[:body],
          options[:headers]
        )
        JSON.parse(response.body) if !response.body.empty?
      end
    end
  end
end
