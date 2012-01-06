module Spree
  class PaymentNotificationsController < BaseController
    protect_from_forgery :except => [:create]
    skip_before_filter :restriction_access
    
    def create      
      if(Spree::PaypalWebsiteStandard::Config.encrypted && (params[:secret] != Spree::PaypalWebsiteStandard::Config.ipn_secret))
        logger.info "PayPal_Website_Standard: attempt to send an IPN with invalid secret"
        raise Exception
      end
      
      @order = Spree::Order.find_by_number(params[:invoice])
      Spree::PaymentNotification.create!(:params => params,
        :order_id => @order.id,
        :status => params[:payment_status],
        :transaction_id => params[:txn_id])
      
      logger.info "PayPal_Website_Standard: processing payment notification for invoice #{params["invoice"]}, amount is #{params["mc_gross"]} #{params["mc_currency"]}"
      # this logging stuff won't live here for long...
      
      Order.transaction do
      # main part of hacks
        order = @order
        
        #create payment for this order
        payment = Spree::Payment.new
        
        # 1. Assume that if payment notification comes, it's exactly for the amount
        # sent to paypal (safe assumption -- cart can't be edited while on paypal)
        # 2. Can't use Order#total, as it's intercepted by spree-multi-currency
        # which might lead to lots of false "credit owed" payment states
        # (when they should be "complete")
        payment.amount = order.read_attribute(:total)
        logger.info "PayPal_Website_Standard: set payment.amount to #{payment.amount} based on order's total #{order.read_attribute(:total)}"
        
        payment.payment_method = Spree::Order.paypal_payment_method
        order.payments << payment
        payment.started_processing
        
        order.payment.complete
        logger.info("PayPal_Website_Standard: order #{order.number} (#{order.id}) -- completed payment")
        while order.state != "complete"
          order.next
          logger.info("PayPal_Website_Standard: advanced state of Order #{order.number} (#{order.id}). current state #{order.state}. thread #{Thread.current.to_s}. issuing callback")
          state_callback(:after) # that line will run all _not run before_ callbacks
        end
        order.update_totals
        order.update!
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
    
    def after_complete
      session[:order_id] = nil
    end
    
    def default_country
      Country.find Spree::PaypalWebsiteStandard::Config.default_country_id
    end
    
  end
end