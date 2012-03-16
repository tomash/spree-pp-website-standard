module Spree
  class PayPalPaymentMethod < PaymentMethod
    def provider_class
      self.class
    end

    def payment_source_class
      self.class
    end

    def source_required?
      false
    end
  end
end
