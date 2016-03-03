module Layer
  module Resources
    class Webhook < Layer::Resource
      def activate
        client.post("#{url}/activate")
      end

      def deactivate
        client.post("#{url}/deactivate")
      end
    end
  end
end
