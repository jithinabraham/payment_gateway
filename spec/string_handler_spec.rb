require '../string_handler.rb'
require '../hash_with_sym.rb'

describe PaymentGateway::RequestStringEncoder do
  
  
  describe '#to_encode' do
    it 'should encode request as expected' do
      params_string = 'bank_ifsc_code=ICIC0000001|bank_account_number=11111111'
      encoded_string = PaymentGateway::RequestStringEncoder.new(params_string).to_encode
      decoded_string = PaymentGateway::RequestStringDecoder.new(encoded_string).to_decode
      expect(decoded_string).to eq(params_string)
    end

    it 'should not result mismatch if encoded string is different' do
      string1 = 'bank_ifsc_code=ICIC0000001|bank_account_number=11111111'
      encoded_string1 = PaymentGateway::RequestStringEncoder.new(string1).to_encode
      string2 = 'bank_ifsc_code=ICIC0000001|bank_account_number=11111111d'
      encoded_string2 = PaymentGateway::RequestStringEncoder.new(string2).to_encode
      
      decoded_string = PaymentGateway::RequestStringDecoder.new(encoded_string2).to_decode
      
      expect(decoded_string).not_to eq(string1)
    end
  end

end
  