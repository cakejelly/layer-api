module Layer
  module Resources
    class Block < Layer::Api::Resource
      def self.list(url, params = {})
        collection = client.get(url, body: params.to_json)

        if collection.any?
          collection.map{ |resource| new({"url" => "#{url}/#{resource['user_id']}"}) }
        else
          []
        end
      end

      def self.create(url, params = {})
        client.post(url, body: params.to_json)
        new({"url" => "#{url}/#{params[:user_id]}"})
      end
    end
  end
end
