module Layer
  module Resources
    class Block < Layer::Resource
      def self.find(url, user)
        user_id = user.instance_of?(User) ? user.id : user
        new_abstract_instance(url, user_id)
      end

      def self.list(url, params = {})
        collection = client.get(url, body: params.to_json)

        if collection.any?
          collection.map{ |resource| new_abstract_instance(url, resource['user_id']) }
        else
          []
        end
      end

      def self.create(url, params = {})
        user_params = params.instance_of?(User) ? {user_id: params.id} : params

        client.post(url, body: user_params.to_json)
        new_abstract_instance(url, user_params[:user_id])
      end

      def self.new_abstract_instance(url, id)
        new({"id" => id, "url" => "#{url}/#{id}"})
      end
    end
  end
end
