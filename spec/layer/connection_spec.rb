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
      expect(@conn.headers).to include(@layer.default_layer_headers)
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
