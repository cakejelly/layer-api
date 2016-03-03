require 'faraday'
require 'json'
require 'jwt'

require "layer/version"
require "layer/http_client"
require "layer/errors"
require "layer/resource"
require "layer/resource_proxy"
require "layer/identity_token"
require "layer/base_client"

# Platform
require "layer/platform/client"

# Webhooks
require "layer/webhooks/client"

# Resources
require "layer/resources/conversation"
require "layer/resources/message"
require "layer/resources/announcement"
require "layer/resources/user"
require "layer/resources/block"
require "layer/resources/webhook"

require "layer/middleware/api_errors"
