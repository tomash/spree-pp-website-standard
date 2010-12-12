class PaymentNotification < ActiveRecord::Base
  belongs_to :order
  serialize :params
  after_create :mark_order_as_paid
  
  private
  
  def mark_order_as_paid
    if(status == "Completed")
      logger.info "Order #{self.order.number} should be marked as paid now -- IPN status 'Completed'"
      #order.update_attributes({:paid_on => Date.today, :status_id => Status.PAID.id}) 
    end  
  end 
end
