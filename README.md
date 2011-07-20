# Spree PayPal Website Standard

A [Spree](http://spreecommerce.com) extension to allow payments using PayPal Website Standard.

## Before you read further

This README is in the process of thorough rework to describe the current codebase, design decisions and how to use it. But at the moment some parts are out-of-date. Please read the code of the extension, it's pretty well commented and structured. 

## Old Introduction (outdated!)

Overrides the default Spree checkout process and uses offsite payment processing via PayPal's Website Payment Standard (WPS).  

You'll want to test this using a paypal sandbox account first.  Once you have a business account, you'll want to turn on Instant Payment Notification (IPN).  This is how your application will be notified when a transaction is complete.  Certain transactions aren't completed immediately.  Because of this we use IPN for your application to get notified when the transaction is complete.  IPN means that our application gets an incoming request from Paypal when the transaction goes through.  

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


## Installation 

Add to your Spree application Gemfile.

    gem "spree_paypal_website_standard", :git => "git://github.com/tomash/spree-pp-website-standard.git"

Run the install rake task to copiy migrations (create payment_notifications table)

    rake pp_website_standard:install

Configure, run, test.


## Configuration

Be sure to configure the following configuration parameters. Preferably put it in initializer like config/initializers/pp_website_standard.rb.

Example:

    Spree::Paypal::Config.set(:account => "foo@example.com") 
    Spree::Paypal::Config.set(:success_url => "http://localhost:3000/paypal/confirm")
    

The following configuration options (keys) can be set:

    :account         # email account of store 
    :success_url     # url the customer is redirected to after successfully completing payment
    :currency_code   # default EUR
    :sandbox_url     # paypal url in sandbox mode, default https://www.sandbox.paypal.com/cgi-bin/webscr
    :paypal_url      # paypal url in production, default https://www.paypal.com/cgi-bin/webscr
    :populate_address # (true/false) pre-populate fields of billing address based on spree order data
    :encryption      # (true/false) use encrypted shopping cart
    :cert_id         # id of certificate used to encrypted stuff
    :ipn_secret      # secret string for authorizing IPN

Only the first three ones need to be set up in order to get running. 

The last three are required for secure, encrypted operation (see below).

## Encryption / Security

The payment link can be encrypted using an SSL key pair and a PayPal public key. In order to attempt this encryption, the following elements must be available. If these are not available a normal link will be generated.

Spree::Paypal::Config[:encrypted] must be set to true.
Spree::Paypal::Config[:cert_id] must be set to a valid certificate id.
Spree::Paypal::Config[:ipn_secret] must be set to a string considered secret.
Application must have a Rails.root/certs directory with following files:

    app_cert.pem # application certificate
    app_key.pem  # application key
    paypal_cert_#{Rails.env}.pem # paypal certificate

The best instructions on what is what, how these files should be generated etc. are [in AsciiCast 143](http://asciicasts.com/episodes/143-paypal-security) (basically the code of this extension is also based on this AsciiCast). 

## IPN Notes (outdated!)

Real world testing indicates that IPN can be very slow.  If you want to test the IPN piece Paypal now has an IPN tool on their developer site.  Just use the correct URL from the hidden field on your Spree checkout screen.  In the IPN tool, change the transaction type to `cart checkout` and change the `mc_gross` variable to match your order total.


## TODO

* README with complete documentation
* Test suite
* Refunds
