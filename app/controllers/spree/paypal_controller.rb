module Spree
  class PaypalController < Spree::CheckoutController
    protect_from_forgery :except => [:confirm]
    skip_before_filter :persist_gender

    def confirm
			logger.info("========= Paypal#Confirm ======")
      unless current_order
        redirect_to root_path
      else
        order = current_order
          while order.state != "complete"
            order.next
            state_callback(:after)
          end

	        if (order.payment_state == "paid") or (order.payment_state == "credit_owed")
	          flash[:notice] = t(:pp_ws_payment_received)
	          state_callback(:after)
						session[:order_id] = nil
						logger.info("========= PayPal: Order #{order.number} (#{order.id}) Already Paid ======")
						logger.debug(current_order)
	        else
          	flash[:notice] = t(:pp_ws_order_processed_successfully)
          	flash[:commerce_tracking] = "nothing special"
	          state_callback(:after)
        	end
        redirect_to order_path(current_order)
      end
    end

  end
end