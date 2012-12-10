class Spree::BillingIntegration::PaypalWebsiteStandard < Spree::BillingIntegration

  preference :account_email, :string
  preference :ipn_notify_host, :string
  preference :success_url, :string
  #sandbox paypal_url: https://www.sandbox.paypal.com/cgi-bin/webscr
  #production paypal_url: https://www.paypal.com/cgi-bin/webscr
  preference :paypal_url, :string, :default => 'https://www.sandbox.paypal.com/cgi-bin/webscr'
  preference :encryption, :boolean, :default => false
  preference :certificate_id, :string
  preference :currency, :string, :default => "USD"
  preference :language, :string, :default => "en"


  def payment_profiles_supported?
    false
  end

end
