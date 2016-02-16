module Layer
  module Resources
    class Block < Layer::Resource
      def self.find(client, url, user)
        user_id = user.instance_of?(User) ? user.id : user
        new_abstract_instance(url, user_id, client)
      end

      def self.list(client, url, params = {})
        collection = client.get(url, body: params.to_json)

        if collection.any?
          collection.map do |resource|
            new_abstract_instance(url, resource['user_id'], client)
          end
        else
          []
        end
      end

      def self.create(client, url, params = {})
        user_params = params.instance_of?(User) ? {user_id: params.id} : params

        client.post(url, body: user_params.to_json)
        new_abstract_instance(url, user_params[:user_id], client)
      end

      def self.new_abstract_instance(url, id, client)
        new({"id" => id, "url" => "#{url}/#{id}"}, client)
      end
    end
  end
end
