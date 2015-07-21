require 'spec_helper'

describe Layer::Api::Connection do

  before do
    @layer = Layer::Api::Client.new
    @conn = @layer.connection
    @default_headers = @layer.default_layer_headers.reject{|k, v| k == 'If-None-Match'}
  end

  describe ".connection" do
    it "should use the default base url" do
      expect(@conn.url_prefix.to_s).to eq(@layer.base_url)
    end

    it "should return a connection containing default layer headers" do
      # Remove If-None-Match header since it's always going to be random
      # and we can't compare it
      expect(@conn.headers).to include(@default_headers)
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

  describe ".run_request" do
    it "should successfully add default layer headers to request" do
      VCR.use_cassette('conversation') do
        request = @layer.run_request(:get, 'users/test/blocks')
        expect(request.env.request_headers).to include(@default_headers)
        expect(request.env.request_headers).to include("If-None-Match")
      end
    end

    it "should make request to url that is supplied as param" do
      VCR.use_cassette('conversation') do
        request_url = 'users/test/blocks'
        request = @layer.run_request(:get, request_url)
        request_actual = request.env.url.to_s.sub("#{@layer.base_url}/", "")

        expect(request_actual).to eq (request_url)
      end
    end

    it "should use the http method that is supplied as a param" do
      VCR.use_cassette('announcement') do
        method = :post
        request = @layer.run_request(method, 'announcements', announcement_params)

        expect(request.env.method).to eq(method)
      end
    end
  end

  describe ".call" do
    it "should run request & return response body" do
      VCR.use_cassette('conversation') do
        existing_conversation = @layer.create_conversation(conversation_params)
        existing_id = @layer.get_stripped_id(existing_conversation["id"])

        url = "#{@layer.base_url}/conversations/#{existing_id}"
        body = @layer.call(:get, url, conversation_params)

        # Compare body with expected values
        expect(body["participants"]).to match_array(conversation_params[:participants])
        expect(body["distinct"]).to eq(conversation_params[:distinct])
        expect(body["metadata"].to_json).to eq(conversation_params[:metadata].to_json)
      end
    end

    it "should run request & return nil if response has no body" do
      VCR.use_cassette('conversation') do
        existing_conversation = @layer.create_conversation(conversation_params)
        existing_conversation_id = @layer.get_stripped_id(existing_conversation["id"])

        operations = [
          {operation: "add", property: "participants", value: "user1"},
          {operation: "add", property: "participants", value: "user2"}
        ]

        response = @layer.edit_conversation(existing_conversation_id, operations)
        expect(response).to be(nil)
      end
    end
  end
end
