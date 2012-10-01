Spree::BaseController.class_eval do
	before_filter :check_current_order

	# Checks if an order exists and if its paid
	# will display the payment success message
	def check_current_order	
		# TODO: Introduce a proper way to check the order payment status
		# Currently the order get removed from the session the moment the
		# spree receives payment and no way of tracking. Might have to introduce
		# other means of checking for payment receival for orders. A possible
		# method would be to have session id sent along with IPN secret and
		# mark a flag on payment notifications after displaying payment received
		# message
		# if current_order \
		# && current_order.completed? 
		# # && ((current_order.payment_state == "paid") or (current_order.payment_state == "credit_owed"))
		# 	flash[:notice] = t(:pp_ws_payment_received)
		# 	@order = current_order
		# 	session[:order_id] = nil

		# 	if current_user
		# 		redirect_to spree.order_path(@order)
		# 	else
		# 		redirect_to root_path
		# 	end
			
		# end
	end

end