class PaypalController < CheckoutController 
  protect_from_forgery :except => [:confirm] 
  skip_before_filter :persist_gender
  
  def confirm
    # XXX It works!
    #redirect_to checkout_state_path("confirm")
    # but we want this:
    unless current_order
      redirect_to root_path
    else
      order = current_order
      while order.state != "complete"
         order.next
         state_callback(:after)
      end
      #order.finalize!
      redirect_to order_path(current_order)
    end
  end

end