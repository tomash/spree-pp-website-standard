Spree::BaseController.class_eval do
	before_filter :check_current_order

	# In case the order has been paid and user did not return to the
	# website with standard paypal return link. The the current order
	# will be checked for received payments and cart will be reset.
	def check_current_order
		if current_order && current_order.line_items.present? \
		&& current_order.state == "complete" \
		&& ((current_order.payment_state == "paid") or (current_order.payment_state == "credit_owed"))
			flash[:notice] = t(:pp_ws_payment_received)
			session[:order_id] = nil
			redirect_to root_path
		end
	end

end