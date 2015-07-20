require 'spec_helper'

describe Layer::Api::Connection do
  before do
    @layer = Layer::Api::Client.new
    @conn = @layer.connection
  end

  describe ".connection" do
    it "should use the default base url" do
      expect(@conn.url_prefix.to_s).to eq(@layer.base_url)
    end

    it "should return a connection containing default layer headers" do
      # Remove If-None-Match header since it's always going to be random
      # and we can't compare it
      default_headers = @layer.default_layer_headers.reject{|k, v| k == 'If-None-Match'}
      expect(@conn.headers).to include(default_headers)
      expect(@conn.headers).to include("If-None-Match")
    end

    it "should use custom api errors middleware" do
      api_errors = Layer::Api::Middleware::ApiErrors
      expect(@conn.builder.handlers).to include(api_errors)
    end

    it "should re-use the same connection object" do
      new_conn = @layer.connection
      expect(@conn.object_id).to eq(new_conn.object_id)
    end
  end
end
