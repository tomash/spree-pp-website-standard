Spree::Order.class_eval do
  has_many :payment_notifications
  
  # SSL certificates for encrypting paypal link
  PAYPAL_CERT_PEM = "#{Rails.root}/certs/paypal_cert_#{Rails.env}.pem" # PayPal’s public certificate (downloaded from PayPal)
  APP_CERT_PEM = "#{Rails.root}/certs/app_cert.pem" # Public Key
  APP_KEY_PEM = "#{Rails.root}/certs/app_key.pem" # Private Key

  # This is a workaround for PayPal's disocunt limitations. Discount cannot be bigger than item total.  
  # E.g: Before calculation 
  # Promo credits : 20
  # Total item cost: 19
  # Shipping: 5
  # --------------------------
  # Becomes:
  # Discount :18.99 (PayPal sees it as a discount) 
  # Total item cost: 19 (cannot be changed, PayPal does the calculation)
  # Shipping : 4.01
  def paypal_cart_adjustments
    pp_adjustments = {}
    # The discount has to be a positive number and shipping is calcuated separately in paypal.
    pp_adjustments[:discount] = (self.adjustment_total - self.ship_total).abs
    
    # for PayPal discount has to be < total item cost
    # deducting the remaining credit from the shipping cost
    if pp_adjustments[:discount] > self.item_total
      pp_adjustments[:ship_cost] = (pp_adjustments[:discount] - (self.item_total + self.ship_total - BigDecimal("0.01"))).abs
      pp_adjustments[:discount] = self.item_total - BigDecimal("0.01")
    else
      pp_adjustments[:ship_cost] = self.ship_total
    end
    pp_adjustments
  end
  
  def payable_via_paypal?
    !!self.class.paypal_payment_method
  end
  
  def self.paypal_payment_method
    Spree::PaymentMethod.select{ |pm| pm.name.downcase =~ /paypal/}.first
  end
  
  def self.use_encrypted_paypal_link?
    Spree::PaypalWebsiteStandard::Config.encrypted &&
    Spree::PaypalWebsiteStandard::Config.ipn_secret &&
    Spree::PaypalWebsiteStandard::Config.cert_id &&
    File.exist?(PAYPAL_CERT_PEM) &&
    File.exist?(APP_CERT_PEM) &&
    File.exist?(APP_KEY_PEM)
  end
  
  def paypal_encrypted(payment_notifications_url, options = {})
    values = {
      :business => Spree::PaypalWebsiteStandard::Config.account,
      :invoice => self.number,
      :cmd => '_cart',
      :upload => 1,
      :currency_code => options[:currency_code] || Spree::PaypalWebsiteStandard::Config.currency_code,
      :handling_cart => self.paypal_cart_adjustments[:ship_cost],
      :discount_amount_cart => self.paypal_cart_adjustments[:discount],
      :return => Spree::PaypalWebsiteStandard::Config.success_url,
      :notify_url => payment_notifications_url,
      :charset => "utf-8",
      :cert_id => Spree::PaypalWebsiteStandard::Config.cert_id,
      :page_style => Spree::PaypalWebsiteStandard::Config.page_style,
      :tax_cart => self.tax_total
    }
    
    self.line_items.each_with_index do |item, index|
      values.merge!({
        "amount_#{index + 1}" => item.price,
        "item_name_#{index + 1}" => item.variant.product.name,
        "item_number_#{index + 1}" => item.variant.product.id,
        "quantity_#{index + 1}" => item.quantity
      })
    end
    
    encrypt_for_paypal(values)
  end
  
  def encrypt_for_paypal(values)
    paypal_cert = File.read(PAYPAL_CERT_PEM)
    app_cert = File.read(APP_CERT_PEM)
    app_key = File.read(APP_KEY_PEM)
    signed = OpenSSL::PKCS7::sign(OpenSSL::X509::Certificate.new(app_cert), OpenSSL::PKey::RSA.new(app_key, ''), values.map { |k, v| "#{k}=#{v}" }.join("\n"), [], OpenSSL::PKCS7::BINARY)
    OpenSSL::PKCS7::encrypt([OpenSSL::X509::Certificate.new(paypal_cert)], signed.to_der, OpenSSL::Cipher::Cipher::new("DES3"), OpenSSL::PKCS7::BINARY).to_s.gsub("\n", "")
  end

end
