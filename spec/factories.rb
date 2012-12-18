FactoryGirl.define do
  factory :paypal_website_standard_payment_method, :class => Spree::BillingIntegration::PaypalWebsiteStandard do
    name 'PaypalWebsiteStandard test'
    environment 'test'
    preferred_account_email "tomekr_1306252132_biz@o2.pl"
    preferred_ipn_notify_host "http://localhost:3000/payment_notifications"
    preferred_success_url "http://localhost:3000/paypal/confirm"
    preferred_paypal_url "https://www.sandbox.paypal.com/cgi-bin/webscr"
    preferred_encryption false
    preferred_server "test"
    preferred_test_mode true
    
  end
end
