module Layer
  class Resource
    attr_reader :attributes, :client

    def initialize(attributes, client)
      @attributes = attributes
      @client = client
    end

    def update(params)
      client.patch(
        url,
        body: params.to_json,
        headers: client.layer_patch_header
      )
    end

    def destroy
      client.delete(url)
    end

    def method_missing(method, *args, &block)
      method_key = method.to_s
      attributes.has_key?(method_key) ? attributes[method_key] : super
    end

    def respond_to_missing?(method, include_private = false)
      method_key = method.to_s
      attributes.has_key?(method_key) ? true : false
    end

    def uuid
      attributes["id"].split("/").last if attributes["id"]
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

      def create(client, url, params = {})
        response = client.post(url, body: params.to_json)
        new(response, client)
      end

      def find(client, url, id)
        response = client.get("#{url}/#{id}")
        new(response, client)
      end

      def list(client, url, params = {})
        collection = client.get(url, body: params.to_json)

        if collection.any?
          collection.map{ |resource| new(resource, client) }
        else
          []
        end
      end
    end
  end
end
