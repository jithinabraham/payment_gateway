module PaymentGateway

	class ClientRequest
		attr_reader :params
		
		def initialize(params)
		 	@params = params.inject({}){|new_hsh,(k,v)| new_hsh[k.to_sym] = v; new_hsh}
		end

		def send_request
			response = ClientRequestBuilder.new(data).post
			display_response(response)
		end

		def display_response(response)
			ClientResponse.new(response).display
		end

		private

		def data
			request = RequestBuilder.new(params)
		    request_data = if request.valid_request?
		    				request.build_request_params
		    			else
		    				{}
		    			end
		  	return request_data
		end

	end

	class ClientRequestBuilder
		require 'net/http'
		require 'uri'
		require 'json'
		URL = "http://localhost:9292/transaction"

		def initialize(data)
			@data = data
		end

		def post
			uri = URI(URL)
			response = Net::HTTP.post_form(uri, @data)
			return response
		end
	end

	class ClientResponse
		require 'json'
		attr_reader :response

		def initialize(response)
			@response = response
		end

		def display
			if response.code != '200'
				print_error_msg
				return
			elsif valid?
				print_params
			else
				print_error_msg
			end
		end

		private

		def valid?
			return false if data.nil?
			valid_response? && is_response_hash_matching?
		end

		def valid_response?
			response_json[:txn_status] && response_json[:amount]&& response_json[:merchant_transaction_ref] && response_json[:transaction_date] && response_json[:payment_gateway_merchant_reference] && response_json[:payment_gateway_transaction_reference]
		end

		def is_response_hash_matching?
			params_json = response_json
			hash_value = params_json.delete(:hash)
			return ParamsMatch.new(params_json,hash_value).is_matching?
		end

		def print_params
			params_json = response_json
			params_json.delete(:hash)
			params_json.each do |key,value|
				puts "#{key} = #{value}"
			end
		end
        
        def status 
        	response.status
        end
		
		def print_error_msg
			puts parsed_response
		end

		def parsed_response
			JSON.parse(response.body)
		end

		def response_json
			RequestDecoder.new(data).response_json
		end

		def data
			parsed_response['msg']
		end
	end

end