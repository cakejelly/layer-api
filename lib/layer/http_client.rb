require 'securerandom'

module Layer
  class HttpClient
    attr_reader :base_url, :default_headers

    def initialize(base_url, default_headers)
      @base_url = base_url
      @default_headers = default_headers
    end

    def connection
      @connection ||= Faraday.new(url: base_url) do |faraday|
        faraday.headers = default_headers
        faraday.request  :url_encoded
        faraday.request  :multipart
        faraday.adapter  Faraday.default_adapter
        faraday.use Middleware::ApiErrors
      end
    end

    def get(url, options = {})
      call(:get, url, options)
    end

    def put(url, options = {})
      call(:put, url, options)
    end

    def post(url, options = {})
      call(:post, url, options)
    end

    def patch(url, options = {})
      call(:patch, url, options)
    end

    def delete(url)
      call(:delete, url)
    end

    def call(method, url, options = {})
      response = run_request(method, url, options)
      response.body.empty? ? true : JSON.parse(response.body)
    end

    def run_request(method, url, options = {})
      headers = options[:headers] || {}
      headers["If-None-Match"] = SecureRandom.uuid

      connection.run_request(
        method,
        url,
        options[:body],
        headers
      )
    end

    def layer_patch_header
      { 'Content-Type' => 'application/vnd.layer-patch+json' }
    end
  end
end
