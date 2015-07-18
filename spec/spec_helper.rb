$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'layer/api'
require 'vcr'
require 'layer_helper'

VCR.configure do |c|
  c.cassette_library_dir = "spec/cassettes"
  c.hook_into :webmock
  c.default_cassette_options = { record: :new_episodes }
  c.filter_sensitive_data('<API_TOKEN>') { ENV['LAYER_API_TOKEN'] }
  c.filter_sensitive_data('<APP_ID>') { ENV['LAYER_APP_ID'] }
end

RSpec.configure do |config|
  config.include LayerHelper
end
