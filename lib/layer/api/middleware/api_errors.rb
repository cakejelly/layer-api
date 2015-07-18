module Layer
  module Api
    module Middleware
      class ApiErrors < Faraday::Response::Middleware
        ERROR_CODES = 400...600

        def on_complete(response)
          if ERROR_CODES.include?(response.status)
            raise Layer::Api::Error.from_response(response)
          end
        end
      end
    end
  end
end
