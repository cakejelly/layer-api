require 'spec_helper'

describe Layer::Api::IdentityToken do
  describe ".new" do
    it "should allow you to set the user_id, nonce and expires_at variables" do
      user_id = "1234"
      nonce = "your_random_nonce"
      expires_at = "12345678"

      # layer = Layer::Api::Client.new
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

  describe ".get_jwt" do
  end

  describe ".headers" do
  end

  describe ".claim" do
  end

  describe ".private_key" do
  end

  describe ".to_s" do
  end

  describe ".generate_identity_token" do
  end
end
