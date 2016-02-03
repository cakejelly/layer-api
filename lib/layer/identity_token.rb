module Layer
  class IdentityToken
    attr_reader :user_id, :nonce, :expires_at

    def initialize(options = {})
      @user_id = options[:user_id]
      @nonce = options[:nonce]
      @expires_at = (options[:expires_at] || Time.now+(1209600))
    end

    def to_s
      get_jwt
    end

    def layer_key_id
      ENV['LAYER_KEY_ID']
    end

    def layer_provider_id
      ENV['LAYER_PROVIDER_ID']
    end

    private

    def get_jwt
      JWT.encode(claim, private_key, 'RS256', headers)
    end

    def headers
      {
        typ: 'JWT',
        cty: 'layer-eit;v=1',
        kid: layer_key_id
      }
    end

    def claim
      {
        iss: layer_provider_id,
        prn: user_id.to_s,
        iat: Time.now.to_i,
        exp: expires_at.to_i,
        nce: nonce
      }
    end

    def private_key
      # Cloud66 stores newlines as \n instead of \\n
      key = ENV['LAYER_PRIVATE_KEY'].dup
      OpenSSL::PKey::RSA.new(key.gsub!("\\n","\n"))
    end
  end
end
