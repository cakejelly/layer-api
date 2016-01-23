require 'faraday'
require 'json'
require 'jwt'

require "layer/api/version"
require "layer/api/http_client"
require "layer/api/client"
require "layer/api/error"
require "layer/api/resource"
require "layer/api/resource_proxy"

require "layer/api/resources/conversation"
require "layer/api/resources/message"
require "layer/api/resources/announcement"

require "layer/api/middleware/api_errors"

module Layer
  module Api
  end
end
