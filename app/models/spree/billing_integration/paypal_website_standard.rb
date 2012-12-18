class Spree::BillingIntegration::PaypalWebsiteStandard < Spree::BillingIntegration

  attr_accessible :preferred_account_email, :preferred_ipn_notify_host, :preferred_success_url, 
    :preferred_paypal_url, :preferred_encryption, :preferred_certificate_id, :preferred_ipn_secret,
    :preferred_currency, :preferred_language,
    :preferred_server, :preferred_test_mode

  preference :account_email, :string
  preference :ipn_notify_host, :string
  preference :success_url, :string
  #sandbox paypal_url: https://www.sandbox.paypal.com/cgi-bin/webscr
  #production paypal_url: https://www.paypal.com/cgi-bin/webscr
  preference :paypal_url, :string, :default => 'https://www.sandbox.paypal.com/cgi-bin/webscr'
  preference :encryption, :boolean, :default => false
  preference :certificate_id, :string, :default => ''
  preference :ipn_secret, :string, :default => ''
  preference :currency, :string, :default => "USD"
  preference :language, :string, :default => "en"


  def payment_profiles_supported?
    false
  end

end
