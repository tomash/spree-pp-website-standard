Spree::BaseController.class_eval do
  before_filter :check_current_order
  def check_current_order
    if current_order or session[:order_id]
      order = current_order
      if (order.payment_state == "paid") or (order.payment_state == "credit_owed")
        session[:order_id] = nil
        order.line_items.destroy_all
        flash[:notice] = t(:pp_ws_payment_received)
      end
    end
  end
end