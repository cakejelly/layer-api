module Layer
  module Websocket
    class Client
      BASE_URL = "https://api.layer.com"

      attr_reader :user_id

      def initialize(user_id)
        @user_id = user_id
      end

      def http_client
        @http_client ||= HttpClient.new(BASE_URL, default_headers)
      end

      def default_headers
        {
          "Content-Type" => "application/json",
          "Accept" => "application/vnd.layer+json; version=1.0"
        }
      end

      def session_token
        response = http_client.post("/sessions", body: session_params.to_json)
        response["session_token"]
      end

      def session_params
        {
          identity_token: identity_token.to_s,
          app_id: ENV["LAYER_APP_ID"]
        }
      end

      def identity_token
        Layer::IdentityToken.new(user_id: user_id, nonce: nonce)
      end

      def nonce
        http_client.post("/nonces")["nonce"]
      end
    end
  end
end
