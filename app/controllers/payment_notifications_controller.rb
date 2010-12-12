class PaymentNotificationsController < ApplicationController
  protect_from_forgery :except => [:create]
  skip_before_filter :restriction_access  
  
  def create  
    @order = Order.find_by_number(params[:invoice])
    PaymentNotification.create!(:params => params, 
      :order_id => @order.id,
      :status => params[:payment_status], 
      :transaction_id => params[:txn_id])
    
    # this logging stuff won't live here for long...

    Order.transaction do
      # main part of hacks
      order = @order
      order.payment.complete
      logger.info("order #{order.number} (#{order.id}) -- completed payment")
      while order.state != "complete"
         order.next
         logger.info("advanced state of Order #{order.number} (#{order.id}). current state #{order.state}. thread #{Thread.current.to_s}. issuing callback")
         state_callback(:after) # that line will run all _not run before_ callbacks
      end
      order.update_totals
      order.update!
      logger.info("Order #{order.number} (#{order.id}) updated successfully, IPN complete")
    end
    
    render :nothing => true
  end
  
  private

  # those methods are copy-pasted from CheckoutController
  # we cannot inherit from that class unless we want to skip_before_filter
  # half of calls in SpreeBase module
  def state_callback(before_or_after = :before)
    method_name = :"#{before_or_after}_#{@order.state}"
    send(method_name) if respond_to?(method_name, true)
  end

  def before_address
    @order.bill_address ||= Address.new(:country => default_country)
    @order.ship_address ||= Address.new(:country => default_country)
  end

  def before_delivery
    @order.shipping_method ||= (@order.rate_hash.first && @order.rate_hash.first[:shipping_method])
  end

  def before_payment
    current_order.payments.destroy_all if request.put?
  end

  def after_complete
    session[:order_id] = nil
  end

  def default_country
    Country.find Spree::Config[:default_country_id]
  end

end
