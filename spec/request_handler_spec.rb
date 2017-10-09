require '../request_handler.rb'
require '../params_handler.rb'
require '../string_handler.rb'
require '../hash_with_sym.rb'

describe PaymentGateway::RequestBuilder do
  
  
  describe '#encode_request' do
    
    it 'should encode and decode as expected' do
      input_params = {bank_ifsc_code: 'ICIC0000001',
                      bank_account_number:'11111111',
                      amount:'10000.00',
                      merchant_transaction_ref: 'txn001',
                      transaction_date: '2014-11-14',
                      payment_gateway_merchant_reference:'merc001'}

      request = PaymentGateway::RequestBuilder.new(input_params)
      encoded_request = request.build_request_params
      decoded_request = PaymentGateway::RequestDecoder.new(encoded_request[:msg]).response_json
      expect(input_params).to eq(decoded_request)
    end

  end

end
  