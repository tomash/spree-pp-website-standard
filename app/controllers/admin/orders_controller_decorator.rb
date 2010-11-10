puts "orders controller decorator loading"

# Add a partial for PaypalPayment txns
Admin::OrdersController.class_eval do
  before_filter :add_pp_standard_txns, :only => :show
  def add_pp_standard_txns
    @txn_partials << 'pp_standard_txns'
  end
end
