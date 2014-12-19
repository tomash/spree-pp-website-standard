module Spree
  class PaymentNotificationsController < BaseController
    protect_from_forgery :except => [:create]
    skip_before_filter :restriction_access
    
    def create
      payment_method = Order.paypal_payment_method
      #if(payment_method.preferences[:encryption] && (params[:secret] != payment_method.preferences[:ipn_secret]))
      #  logger.info "PayPal_Website_Standard: attempt to send an IPN with invalid secret"
      #  raise Exception
      #end
      
      @order = Spree::Order.find_by_number(params[:invoice])
      Spree::PaymentNotification.create!(:params => params,
        :order_id => @order.id,
        :status => params[:payment_status],
        :transaction_id => params[:txn_id])
      
      logger.info "PayPal_Website_Standard: processing payment notification for invoice #{params["invoice"]}, amount is #{params["mc_gross"]} #{params["mc_currency"]}"
      
      Order.transaction do
      # main part of hacks
        order = @order
        
        #create payment for this order
        payment = Spree::Payment.new
        
        # payment.amount = order.read_attribute(:total)
        payment.amount = params[:mc_gross].to_f
        logger.info "PayPal_Website_Standard: set payment.amount to #{payment.amount} based on order's total #{order.read_attribute(:total)}"
        
        payment.payment_method = Spree::Order.paypal_payment_method
        order.payments << payment
        payment.started_processing
        
        payment.complete!
        logger.info("PayPal_Website_Standard: order #{order.number} (#{order.id}) -- completed payment")
        @order.reload # otherwise it might not see the newly added payment
        @order.update!
        if @order.can_go_to_state?("complete")
          until @order.state == "complete"
            @order.next!
            @order.update!
            state_callback(:after)
          end
        end

        logger.info("PayPal_Website_Standard: Order #{order.number} (#{order.id}) updated successfully, IPN complete")
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
    
		#This isn't working here in payment_nofitications_controller since IPN will run on a different session
    def after_complete
      session[:order_id] = nil
    end
    
    def default_country
      Country.find Spree::PaypalWebsiteStandard::Config.default_country_id
    end
    
  end
end
