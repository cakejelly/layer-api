require "spec_helper"

describe Layer::Websocket::Client do
  user_id = "user_id"
  let(:client) { described_class.new(user_id) }

  describe "#new" do
    it "should take a user id argument" do
      expect(client.user_id).to eq(user_id)
    end
  end

  describe "#default_headers" do
    it "should return the default headers needed for successful requests" do
      expect(client.default_headers).to eq(default_headers)
    end
  end

  describe "#http_client" do
    it "should return instance of HttpClient" do
      expect(client.http_client).to be_instance_of(Layer::HttpClient)
    end

    it "should set the correct default headers" do
      expect(client.http_client.default_headers).to eq(default_headers)
    end
  end

  describe "#nonce" do
    let(:nonce) { {"nonce" => "some_random_nonce"} }

    before do
      allow(client.http_client).to receive(:post).and_return(nonce)
    end

    it "should make a POST request to retrieve a nonce" do
      expect(client.nonce).to eq(nonce["nonce"])
    end
  end

  describe "#identity_token" do
    let(:nonce) { "derpyderp" }

    before do
      allow(client).to receive(:nonce).and_return(nonce)
    end

    it "should return an instance of Layer::IdentityToken" do
      expect(client.identity_token).to be_instance_of(Layer::IdentityToken)
    end

    it "should pass the user_id" do
      expect(client.identity_token.user_id).to eq(user_id)
    end

    it "should pass the nonce" do
      expect(client.identity_token.nonce).to eq(nonce)
    end
  end

  describe "#session_params" do
    let(:mock_identity_token) { instance_double("Layer::Identity_token") }
    let(:identity_token) { "some.identity.token" }

    before do
      @temp_app_id = ENV["LAYER_APP_ID"]
      ENV["LAYER_APP_ID"] = "layer_app_id"

      allow(mock_identity_token).to receive(:to_s).and_return(identity_token)
      allow(client).to receive(:identity_token).and_return(mock_identity_token)
    end

    it "should return a Hash" do
      expect(client.session_params).to be_instance_of(Hash)
    end

    it "should contain an 'app_id' attribute" do
      expect(client.session_params[:app_id]).to eq(ENV["LAYER_APP_ID"])
    end

    it "should contain an 'identity_token' attribute" do
      expect(client.session_params[:identity_token]).to eq(identity_token)
    end

    after do
      ENV["LAYER_APP_ID"] = @temp_app_id
    end
  end

  describe "#session_token" do
    let(:session) { { "session_token" => "some_token" } }
    let(:session_params) { { param: "value" } }

    before do
      allow(client).to receive(:session_params).and_return(session_params)
      allow(client.http_client).to receive(:post).and_return(session)
    end

    it "should make POST request to create new session" do
      client.session_token

      expect(client.http_client).to have_received(:post)
                                     .with("/sessions", body: session_params.to_json)
    end

    it "should return a string" do
      expect(client.session_token).to be_instance_of(String)
    end
  end

  def default_headers
    {
      "Content-Type" => "application/json",
      "Accept" => "application/vnd.layer+json; version=1.0"
    }
  end
end
