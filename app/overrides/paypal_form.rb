Deface::Override.new(:virtual_path => "spree/checkout/edit",
                     :surround_contents => "[data-hook='checkout_form_wrapper']",
                     :text => "<% if pay_with_paypal? -%><%= render :partial => 'spree/checkout/paypal_checkout' %><% else -%><%= render_original %><% end -%>",
                     :name => "paypal_form")
