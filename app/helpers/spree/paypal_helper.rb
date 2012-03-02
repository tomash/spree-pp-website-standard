module Spree
  module PaypalHelper
    def pay_with_paypal?
      @order.state == 'payment' and @order.payable_via_paypal?
    end
  end
end
