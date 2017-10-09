module PaymentGateway
	
	class RequestBase
		attr_reader :params
		def initialize(params = {})
			@params = params
		end

		def valid_request?
			params[:bank_ifsc_code] && params[:bank_account_number] && params[:amount]  && params[:merchant_transaction_ref] && params[:transaction_date] && params[:payment_gateway_merchant_reference]
		end

		def valid_response?
			params[:txn_status] && params[:amount]&& params[:merchant_transaction_ref] && params[:transaction_date] && params[:payment_gateway_merchant_reference] && params[:payment_gateway_transaction_reference]						
		end
	end

	class RequestBuilder < RequestBase
		def build_request_params
			request_hash = {}
			add_sha1_digest
			encoded_params = encode_request
			request_hash[:msg] = encoded_params
			return request_hash
		end
		
		private

		def add_sha1_digest
			encoded_params = encode_params
			params[:hash] = ShaOneDigest.new(encoded_params).to_hexdigest
		end

		def encode_request
			RequestStringEncoder.new(encode_params).to_encode
		end
		
		def encode_params
			ParamsEncoder.new(params).to_string
		end

	end

	class RequestDecoder 
        attr_reader :data    
        
        def initialize(data)
        	@data = data
        end
        
        def response_json
            ParamsDecoder.new(decode_data).to_hash
        end

        private

        def decode_data
        	RequestStringDecoder.new(data).to_decode
        end
    end
end