module PaymentGateway

  class ParamsDecoder

    def initialize(string_value)
      @string_value = string_value
    end

    def valid?
      @string_value.nil?
    end

    def to_hash
      hsh = {}
      string_array = @string_value.split(/\|/)
      string_array.each do |text|
        key, value = text.split(/\=/)
        hsh[key] = value
      end
      return hsh.with_sym
    end
  end

  class ParamsEncoder
    def initialize(opts = {})
      @options = opts
    end

    def valid?
      @options.all? { |key, value| !value.nil? }
    end

    def to_string
      return if !valid?
      string_array = []
      @options.each do |key, value|
        string_array << "#{key}=#{value}"
      end
      string_array.join("|")
    end
  end

  class ParamsMatch
    def initialize(params, hash_value)
      @params, @hash_value = params, hash_value
    end

    def is_matching?
      params_hash_value == @hash_value
    end

    def params_hash_value
      ShaOneDigest.new(encode_params).to_hexdigest
    end

    def encode_params
      ParamsEncoder.new(@params).to_string
    end
  end

  class ShaOneDigest
    require 'digest'

    def initialize(text)
      @text = text
    end

    def to_hexdigest
      Digest::SHA1.hexdigest(@text)
    end
  end

end