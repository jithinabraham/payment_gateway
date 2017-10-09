module PaymentGateway
  class Server
    require 'json'
    attr_reader :status, :params

    def initialize(params)
      @params = params.with_sym
      @status = nil
    end

    def get_json_response
      response = {}
      if valid?
        response = transaction_response
      else
        response[:error] = 'invalid request'
      end
      return response.to_json
    end

    def process_request
      @status = 200 if valid?
    end

    private

    def valid?
      return false unless params[:msg]
      is_valid_input? && is_input_hash_matching?
    end

    def transaction_response
      transaction = Transaction.new(response_json)
      transaction.make_transaction
      return transaction.response
    end

    def is_input_hash_matching?
      params_json = response_json
      hash_value = params_json.delete(:hash)
      return ParamsMatch.new(params_json, hash_value).is_matching?
    end

    def is_valid_input?
      response_json[:bank_ifsc_code] && response_json[:bank_account_number] && response_json[:amount] && response_json[:merchant_transaction_ref] && response_json[:transaction_date] && response_json[:payment_gateway_merchant_reference]
    end

    def response_json
      RequestDecoder.new(data).response_json
    end

    def data
      params[:msg]
    end
  end


  class Transaction
    attr_reader :params

    def initialize(params)
      @params = params
    end

    def response
      request = RequestBuilder.new(response_msg)
      _response = if request.valid_response?
                    request.build_request_params
                  else
                    {}
                  end
      return _response
    end

    def make_transaction
      if valid_info?
        return true if debit_amount_from_client(params[:amount])
      end
    end

    private

    def response_msg
      # dummy data
      {txn_status: 'success',
       amount: params[:amount],
       merchant_transaction_ref: 'referense_number',
       transaction_date: params[:transaction_date],
       payment_gateway_merchant_reference: params[:payment_gateway_merchant_reference],
       payment_gateway_transaction_reference: 'pg_txn0001'}
    end

    def valid_info?
      # validate_information
      true
    end

    def debit_amount_from_client(amount)
      # debit amount from merchant
      true
    end
  end
end