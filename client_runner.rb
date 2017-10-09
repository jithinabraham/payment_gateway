require './hash_with_sym.rb'
require './params_handler.rb'
require './request_handler.rb'
require './string_handler.rb'
require './client.rb'


input_params = {bank_ifsc_code: 'ICIC0000001',
	bank_account_number:'11111111',
	amount:'10000.00',
	merchant_transaction_ref: 'txn001',
	transaction_date: '2014-11-14',
	payment_gateway_merchant_reference:'merc001'}

PaymentGateway::ClientRequest.new(input_params).send_request
