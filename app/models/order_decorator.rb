Order.class_eval do 
  has_many :paypal_payments
  
  def shipment_cost
    adjustment_total - credit_total
  end
end
