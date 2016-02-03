module Layer
  module Resources
    class Block < Layer::Resource
      def self.list(url, params = {})
        collection = client.get(url, body: params.to_json)

        if collection.any?
          collection.map{ |resource| new({"url" => "#{url}/#{resource['user_id']}"}) }
        else
          []
        end
      end

      def self.create(url, params = {})
        user_params = params.instance_of?(User) ? {user_id: params.id} : params

        client.post(url, body: user_params.to_json)
        new({"url" => "#{url}/#{user_params[:user_id]}"})
      end
    end
  end
end
