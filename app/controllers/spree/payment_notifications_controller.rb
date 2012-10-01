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

        payment.complete!
        @order.update_attributes({:state => "complete", :completed_at => Time.now}, :without_protection => true)
        logger.info("PayPal_Website_Standard: order #{order.number} (#{order.id}) -- completed payment")

        if @order.respond_to?(:consume_users_credit, true)
          @order.send(:consume_users_credit)
        end

        @order.finalize!

        logger.info("PayPal_Website_Standard: Order #{order.number} (#{order.id}) updated successfully, IPN complete")
      end
      
      render :nothing => true
    end
    
    private
    #########################

            
  end
end