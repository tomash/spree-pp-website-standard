puts "loading paypal_payment model..."

class PaypalPayment < Payment
  has_many :paypal_txns  
  alias :txns :paypal_txns
end
