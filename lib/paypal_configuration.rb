class PaypalConfiguration < Configuration

  # the url parameters should not need to be changed (unless paypal changes the api or something other major change)
  preference :sandbox_url, :string, :default => "https://www.sandbox.paypal.com/cgi-bin/webscr"
  preference :paypal_url, :string, :default => "https://www.paypal.com/cgi-bin/webscr"
  
  # these are just default preferences of course, you'll need to change them to something meaningful
  preference :account, :string, :default => "foo@example.com"
  preference :success_url, :string, :default => "http://localhost:3000/paypal/confirm"
  
  # this stuff is really handy
  preference :currency_code, :string, :default => "EUR"
  preference :page_style, :string, :default => 'PayPal'
  
  # encryption / security
  preference :encrypted, :boolean, :default => false
  preference :cert_id, :string, :default => "12345678"
  preference :ipn_secret, :string, :default => "secret"

  # encoding
  preference :force_encoding, :boolean, :default => false

  validates_presence_of :name
  validates_uniqueness_of :name
end
