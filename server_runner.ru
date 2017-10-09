
class ServerRunner
	require 'rack'
	require './hash_with_sym.rb'
	require './params_handler.rb'
	require './request_handler.rb'
	require './string_handler.rb'
	require './server.rb'
	def self.call(env)
		request = Rack::Request.new(env)
		if request.path_info == '/transaction'
			if request.request_method == 'POST'
				begin
					req = PaymentGateway::Server.new(request.params)
				rescue PaymentGateway::Server::InvalidParams => error
              		[400, {"Content-Type" => "text/json"}, [error.message] ]
              	end
              	begin
              		req.process_request
              	rescue =>error
              		[500,{"Content-Type" => "text/json"},[error.message]]
              	end
              	[req.status,{"Content-Type" => "text/json"},[req.get_json_response]]
			else
				[404, {}, ['page not found']]
			end
		else
			[404, {}, ['page not found']]
		end
	end
end


run ServerRunner
