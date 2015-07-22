require 'spec_helper'

describe Layer::Api::IdentityToken do
  describe ".new" do
    it "should allow you to set the user_id, nonce and expires_at variables" do
      user_id = "1234"
      nonce = "your_random_nonce"
      expires_at = "12345678"

      token = Layer::Api::IdentityToken.new(
        user_id: user_id,
        nonce: nonce,
        expires_at: expires_at
      )

      expect(token.user_id).to eq(user_id)
      expect(token.nonce).to eq(nonce)
      expect(token.expires_at).to eq(expires_at)
    end
  end

  describe ".layer_key_id" do
    it "should return your ENV['LAYER_KEY_ID']" do
      layer_key_id = Layer::Api::IdentityToken.new.layer_key_id
      expect(layer_key_id).to eq(ENV['LAYER_KEY_ID'])
    end
  end

  describe ".layer_provider_id" do
    it "should return your ENV['LAYER_PROVIDER_ID']" do
      provider_id = Layer::Api::IdentityToken.new.layer_provider_id
      expect(provider_id).to eq(ENV['LAYER_PROVIDER_ID'])
    end
  end

  describe ".headers" do
    it "should return necessary headers" do
      token = Layer::Api::IdentityToken.new

      headers = token.send(:headers)

      expect(headers[:kid]).to eq(ENV['LAYER_KEY_ID'])
      expect(headers[:cty]).to eq('layer-eit;v=1')
      expect(headers[:typ]).to eq('JWT')
    end
  end

  describe ".claim" do
    it "should return necessary payload" do
      token = Layer::Api::IdentityToken.new(
        user_id: "user_id",
        nonce: "nonce",
        expires_at: 1234567
      )

      claim = token.send(:claim)

      expect(claim[:iss]).to eq(token.layer_provider_id)
      expect(claim[:prn]).to eq(token.user_id)
      expect(claim[:exp]).to eq(token.expires_at)
      expect(claim[:nce]).to eq(token.nonce)
    end
  end

  describe ".private_key" do
    it "should return valid rsa private key" do
      key = Layer::Api::IdentityToken.new.send(:private_key)
      expect(key).to be_instance_of(OpenSSL::PKey::RSA)
    end
  end

  describe ".to_s" do
    it "should return a string representation of the identity token" do
      token = Layer::Api::IdentityToken.new.to_s
      expect(token).to be_instance_of(String)
    end
  end

  describe ".generate_identity_token" do
    it "should return the correct IdentityToken" do
      options = {}
      options[:user_id] = "user_id"
      options[:nonce] = "user_id"
      layer = Layer::Api::Client.new
      expected_token = Layer::Api::IdentityToken.new(options).to_s
      actual_token = layer.generate_identity_token(options)

      expect(actual_token).to eq(expected_token)
    end
  end
end
