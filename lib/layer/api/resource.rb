module Layer
  module Api
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

      def url
        attributes['url']
      end

      def client
        self.class.client
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
          Layer::Api::HttpClient.new(
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
      end
    end
  end
end
