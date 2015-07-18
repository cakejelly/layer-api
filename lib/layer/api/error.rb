module Layer
  module Api
    class Error < StandardError
      def initialize(response)
        @response = response
        super(build_error_message)
      end

      private

      def build_error_message
        message = "Layer responded with status "
        message << "#{@response[:status]}: #{@response[:body]}"
        message
      end
    end
  end
end
