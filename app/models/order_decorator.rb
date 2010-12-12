Order.class_eval do
  has_many :payment_notifications
  
  def shipment_cost
    adjustment_total - credit_total
  end
end
