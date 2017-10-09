module PaymentGateway

  class RequestStringBase
    SECRET_KEY = 'Q9fbkBF8au24C9wshGRW9ut8ecYpyXye5vhFLtHFdGjRg3a4HxPYRfQaKutZx5N4'
    require 'openssl'
    require 'base64'

    def initialize(data)
      @data = data
    end
  end


  class RequestStringEncoder < RequestStringBase

    def to_encode
      base64_encode
    end

    private

    def base64_encode
      Base64.encode64(aes_128_cbc_encrypt)
    end

    def aes_128_cbc_encrypt
      cipher = OpenSSL::Cipher::AES.new(128, :CBC)
      cipher.encrypt
      cipher.key = SECRET_KEY
      cipher.update(@data) + cipher.final
    end
  end


  class RequestStringDecoder < RequestStringBase

    def to_decode
      aes_128_cbc_dencrypt
    end

    private

    def aes_128_cbc_dencrypt
      cipher = OpenSSL::Cipher::AES.new(128, :CBC)
      cipher.decrypt
      cipher.key = SECRET_KEY
      cipher.update(base64_decode) + cipher.final
    end

    def base64_decode
      Base64.decode64(@data)
    end
  end

end
