# Spree::BaseController.class_eval do
# 	before_filter :check_current_order
# 	def check_current_order
# 
#     def confirm
#       if current_order && (current_order.payment_state == "paid" or current_order.payment_state == "credit_owed")
#         order = current_order
#           while order.state != "complete"
#             order.next
#             state_callback(:after)
#           end
# 					flash[:notice] = t(:pp_ws_payment_received)
#       end
#     end
# 
# 
# 	end
# 
#   private
# 
#   # those methods are copy-pasted from CheckoutController
#   # we cannot inherit from that class unless we want to skip_before_filter
#   # half of calls in SpreeBase module
#   def state_callback(before_or_after = :before)
#     method_name = :"#{before_or_after}_#{@order.state}"
#     send(method_name) if respond_to?(method_name, true)
#   end
#   
#   def before_address
#     @order.bill_address ||= Address.new(:country => default_country)
#     @order.ship_address ||= Address.new(:country => default_country)
#   end
#   
#   def before_delivery
#     @order.shipping_method ||= (@order.rate_hash.first && @order.rate_hash.first[:shipping_method])
#   end
#   
#   def before_payment
#     current_order.payments.destroy_all if request.put?
#   end
#   
# 	#This isn't working here in payment_nofitications_controller since IPN will run on a different session
#   def after_complete
#     session[:order_id] = nil
#   end
#   
#   def default_country
#     Country.find Spree::PaypalWebsiteStandard::Config.default_country_id
#   end
# 
# end