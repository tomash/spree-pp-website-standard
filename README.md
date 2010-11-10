# Spree Pp Website Standard

Overrides the default Spree checkout process and uses offsite payment processing via PayPal's Website Payment Standard (WPS).  

You'll want to test this using a paypal sandbox account first.  Once you have a business account, you'll want to turn on Instant Payment Notification (IPN).  This is how your application will be notified when a transaction is complete.  Certain transactions aren't completed immediately.  Because of this we use IPN for your application to get notified when the transaction is complete.  IPN means that our application gets an incoming request from Paypal when the transaction goes through.  

Regarding Taxes, we assumed you'd want to use Paypal's system for this, which can also be configured through the "profile" page. Shipping cost is being calculated and sent to PayPal along with order contents.


You may want to implement your own custom logic by adding 'state_machine' hooks.  Just add these hooks in your site extension (don't change the 'pp_website_standard' extension.) Here's an example of how to add the hooks to your site extension.


    fsm = Order.state_machines['state']  
    fsm.after_transition :to => 'paid', :do => :after_payment
    fsm.after_transition :to => 'pending_payment', :do => :after_pending  
    
    Order.class_eval do  
      def after_payment
        # email user and tell them we received their payment
      end
      
      def after_pending
        # email user and thell them that we are processing their order, etc.
      end
    end


## Configuration

Be sure to configure the following configuration parameters. Preferably put it in initializer like config/initializers/my_store.rb.  

Example:

    Spree::Paypal::Config[:account] = "foo@example.com"
    Spree::Paypal::Config[:ipn_notify_host] = "http://123.456.78:3000"
    Spree::Paypal::Config[:success_url] = "http://localhost:3000/checkout/success"


## Installation 

    Add to your Spree application Gemfile.  

## IPN Notes

Real world testing indicates that IPN can be very slow.  If you want to test the IPN piece Paypal now has an IPN tool on their developer site.  Just use the correct URL from the hidden field on your Spree checkout screen.  In the IPN tool, change the transaction type to `cart checkout` and change the `mc_gross` variable to match your order total.

* TODO: Taxes
* TODO: Shipping
* TODO: Refunds
