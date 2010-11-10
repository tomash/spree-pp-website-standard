puts "orders controller decorator loading..."

# Add a filter to the OrdersController so that if user is reaching us from an email link we can 
# associate the order with the user (once they log in)
OrdersController.class_eval do
  before_filter :associate_order, :only => :show
  private
  def associate_order  
    return unless payer_id = params[:payer_id]
    orders = Order.find(:all, :include => :paypal_payments, :conditions => ['payments.payer_id = ? AND orders.user_id is null', payer_id])
    orders.each do |order|
      order.update_attribute("user", current_user)
    end
  end
end
