module Layer
  class Error < StandardError
    def self.from_response(response)
      status = response[:status]

      if klass = case status
                 when 400 then Layer::Errors::BadRequest
                 when 404 then Layer::Errors::NotFound
                 when 500..599 then Layer::Errors::ServerError
                 else self
                 end
        klass.new(response)
      end
    end

    def initialize(response)
      @response = response
      super(build_error_message)
    end

    def response
      @response
    end

    private

    def build_error_message
      message = "Layer responded with status "
      message << "#{@response[:status]}: #{@response[:body]}"
      message
    end
  end

  module Errors
    class BadRequest < Error; end
    class NotFound < Error; end
    class ServerError < Error; end
  end
end
