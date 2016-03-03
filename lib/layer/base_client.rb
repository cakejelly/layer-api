module Layer
  class BaseClient
    DEFAULT_HOST = "https://api.layer.com"

    def client
      @http_client ||= Layer::HttpClient.new(base_url, default_headers)
    end

    def strip_layer_prefix(string)
      string.split("/").last if string
    end

    def default_headers
      {
        'Accept' => 'application/vnd.layer+json; version=1.0',
        'Content-Type' => 'application/json'
      }
    end

    def base_url
      DEFAULT_HOST
    end
  end
end
