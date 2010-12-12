class PaymentNotificationsController < CheckoutController
  protect_from_forgery :except => [:create]
  skip_before_filter :restriction_access  
  
  def create  
    @order = Order.find_by_number(params[:invoice])
    PaymentNotification.create!(:params => params, 
      :order_id => Order.number_eq(params[:invoice]).first,
      :status => params[:payment_status], 
      :transaction_id => params[:txn_id])
    
    # this logging stuff won't live here for long...

    logger.info("created PP Notification for order #{@order.number} (#{@order.id}). thread #{Thread.current.to_s}")

    Order.transaction do
      # main part of hacks
      order = @order
      order.payment.complete
      logger.info("order #{order.number} (#{order.id}) -- completed payment")
      while order.state != "complete"
         logger.info("advancing state of Order #{order.number} (#{order.id}). current state #{order.state}. thread #{Thread.current.to_s}")
         order.next
         logger.info("advanced state of Order #{order.number} (#{order.id}). current state #{order.state}. thread #{Thread.current.to_s}. issuing callback")
         state_callback(:after) # that line will run all _not run before_ callbacks
         logger.info("Order #{order.number} (#{order.id}) -- callback complete")
      end
      order.update_totals
      order.update!
      logger.info("Order #{order.number} (#{order.id}) updated successfully, IPN complete")
    end
    
    render :nothing => true
  end

end
