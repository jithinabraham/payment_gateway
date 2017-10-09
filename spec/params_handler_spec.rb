require '../params_handler.rb'
require '../hash_with_sym.rb'

describe PaymentGateway::ParamsEncoder do
  
  it {should respond_to :to_string }
  
  describe '#to_string' do
    it 'should convert hash to string format' do
      hash = {bank_ifsc_code: 'ICIC0000001',bank_account_number:'11111111'}
      params_encoder = PaymentGateway::ParamsEncoder.new(hash)
      expect(params_encoder.to_string).to eq ('bank_ifsc_code=ICIC0000001|bank_account_number=11111111')
    end
    it 'should return nil if input is not valid' do
      hash = {bank_ifsc_code: nil,
              bank_account_number:'11111111'}
      params_encoder = PaymentGateway::ParamsEncoder.new(hash)
      expect(params_encoder.to_string).to eq (nil)
    end
  end
end

describe PaymentGateway::ParamsDecoder do
  
  describe '#to_hash' do
    it 'should convert valid to string hash' do
      string = 'bank_ifsc_code=ICIC0000001|bank_account_number=11111111'
      params_decoder = PaymentGateway::ParamsDecoder.new(string)
      expect(params_decoder.to_hash).to eq ({bank_ifsc_code: 'ICIC0000001',bank_account_number:'11111111'})
    end
    
  end
end

describe PaymentGateway::ParamsMatch do
  describe '#is_matching?' do
    it 'should match if params and hash are equal ' do
      params_hash = {bank_ifsc_code: 'ICIC0000001',bank_account_number:'11111111'}
      params_string = 'bank_ifsc_code=ICIC0000001|bank_account_number=11111111'
      hash_value = PaymentGateway::ShaOneDigest.new(params_string).to_hexdigest
      params_match = PaymentGateway::ParamsMatch.new(params_hash,hash_value)
      expect(params_match.is_matching?).to eq(true)
    end

    it 'should not match if params and hash are not equal ' do
      params_hash = {bank_ifsc_code: 'ICIC0000001',bank_account_number:'11111111'}
      params_string = 'bank_ifsc_code=ICIC0000001|bank_account_number=1113453'
      hash_value = PaymentGateway::ShaOneDigest.new(params_string).to_hexdigest
      params_match = PaymentGateway::ParamsMatch.new(params_hash,hash_value)
      expect(params_match.is_matching?).to eq(false)
    end
  end
end