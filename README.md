# Spree PayPal Website Standard

A [Spree](http://spreecommerce.com) extension to allow payments using PayPal Website Standard.

[![Build Status](https://secure.travis-ci.org/tomash/spree-pp-website-standard.png)](http://travis-ci.org/tomash/spree-pp-website-standard)

## Before you read further

This README is in the process of thorough rework to describe the current codebase, design decisions and how to use it. But at the moment some parts are out-of-date. Please read the code of the extension, it's pretty well commented and structured. 

## Installation 

Add to your Spree application Gemfile.

    gem "spree_paypal_website_standard", :git => "git://github.com/tomash/spree-pp-website-standard.git"

Run the install rake task to copy migrations (create payment_notifications table)

    rails generate spree_paypal_website_standard:install

Configure, run, test.


## Configuration

Go to Spree backend (admin panel). Add a new Payment Method. Choose `Spree::BillingIntegration::PaypalWebsiteStandard` as provider.

Take a while to inspect configuration options and their defaults (suited for development). The following configuration options (keys) can be set:

    account_email    # email account of store (business)
    ipn_notify_host  # host which Paypal will use for sending callbacks (usually the same host as store itself) 
    success url      # url the customer is redirected to after successfully completing payment
    currency_code    # default USD
    paypal_url       # paypal url in production,
                     # use https://www.sandbox.paypal.com/cgi-bin/webscr (default) in development
                     # and https://www.paypal.com/cgi-bin/webscr in production
    encryption       # (true/false) use encrypted shopping cart (leave false NOT SUPPORTED AT THE MOMENT)
    certificate_id   # id of certificate used to encrypted stuff
    ipn_secret       # secret string for authorizing IPN (NOT SUPPORTED AT THE MOMENT)

Only the first three ones need to be set up in order to get running. 

The last three are required for secure, encrypted operation (see below).

## Encryption / Security

TODO: Update this guide, we now (should) use configuration variables provided in backend instead of initializer-set Spree::Paypal::Config object.

The payment link can be encrypted using an SSL key pair and a PayPal public key. In order to attempt this encryption, the following elements must be available. If these are not available a normal link will be generated.

Spree::Paypal::Config[:encrypted] must be set to true.
Spree::Paypal::Config[:cert_id] must be set to a valid certificate id.
Spree::Paypal::Config[:ipn_secret] must be set to a string considered secret.
Application must have a Rails.root/certs directory with following files:

    app_cert.pem # application certificate
    app_key.pem  # application key
    paypal_cert_#{Rails.env}.pem # paypal certificate

The best instructions on what is what, how these files should be generated etc. are [in AsciiCast 143](http://asciicasts.com/episodes/143-paypal-security) (basically the code of this extension is also based on this AsciiCast). 


## Testing

Be sure to bundle your dependencies and then create a dummy test app for the specs to run against.

    $ bundle
    $ bundle exec rake test_app
    $ bundle exec rspec spec


## TODO

* Complete README which is up to date with code, describing design decisions
* Less invasive front-end code
* Better test suite
* Support refunds
