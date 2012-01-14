module Spree
  class PaypalController < Spree::CheckoutController
    protect_from_forgery :except => [:confirm]
    skip_before_filter :persist_gender

    def confirm
      unless current_order
        redirect_to root_path
      else
        order = current_order

        while order.state != "complete"
          order.next
          state_callback(:after)
        end

				flash[:notice] = t(:pp_ws_order_processed_successfully)
				flash[:commerce_tracking] = "nothing special"
				state_callback(:after)
				redirect_to order_path(current_order)
      end
    end

  end
end