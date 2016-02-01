module Layer
  class Resource
    attr_reader :attributes, :client

    def initialize(attributes)
      @attributes = attributes
    end

    def update(params)
      client.patch(url,
                   body: params.to_json,
                   headers: client.layer_patch_header
                  )
    end

    def destroy
      client.delete(url)
    end

    def client
      self.class.client
    end

    def method_missing(method, *args, &block)
      method_key = method.to_s
      attributes.has_key?(method_key) ? attributes[method_key] : super
    end

    def respond_to_missing?(method, include_private = false)
      method_key = method.to_s
      attributes.has_key?(method_key) ? true : false
    end

    class << self
      def class_name
        name.split("::").last
      end

      def pluralized_name
        "#{class_name}s"
      end

      def url
        pluralized_name.downcase
      end

      def client
        Layer::HttpClient.new(
          ENV['LAYER_APP_ID'],
          ENV['LAYER_API_TOKEN']
        )
      end

      def create(url, params = {})
        response = client.post(url, body: params.to_json)
        new(response)
      end

      def find(url, id)
        response = client.get("#{url}/#{id}")
        new(response)
      end

      def list(url, params = {})
        collection = client.get(url, body: params.to_json)

        if collection.any?
          collection.map{ |resource| new(resource) }
        else
          []
        end
      end
    end
  end
end
