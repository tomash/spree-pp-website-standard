Order.class_eval do
  has_many :payment_notifications
  
  def shipment_cost
    adjustment_total - credit_total
  end
  
  def payable_via_paypal?
    !!self.class.paypal_payment_method
  end

  def self.paypal_payment_method
    PaymentMethod.select{ |pm| pm.name.downcase =~ /paypal/}.first
  end
  
  def paypal_encrypted(payment_notifications_url)
    values = {
      :business => Spree::Paypal::Config[:account],
      :invoice => self.number,
      :cmd => '_cart',
      :upload => 1,
      :currency_code => Spree::Paypal::Config[:currency_code],
      :handling_cart => self.ship_total,
      :return => Spree::Paypal::Config[:success_url],
      :notify_url => payment_notifications_url,
      :charset => "utf-8",
      :cert_id => Spree::Paypal::Config[:cert_id]
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
  
  PAYPAL_CERT_PEM = File.read("#{Rails.root}/certs/paypal_cert_#{Rails.env}.pem")  
  APP_CERT_PEM = File.read("#{Rails.root}/certs/app_cert.pem")  
  APP_KEY_PEM = File.read("#{Rails.root}/certs/app_key.pem")  
  def encrypt_for_paypal(values)  
    signed = OpenSSL::PKCS7::sign(OpenSSL::X509::Certificate.new(APP_CERT_PEM), OpenSSL::PKey::RSA.new(APP_KEY_PEM, ''), values.map { |k, v| "#{k}=#{v}" }.join("\n"), [], OpenSSL::PKCS7::BINARY)  
    OpenSSL::PKCS7::encrypt([OpenSSL::X509::Certificate.new(PAYPAL_CERT_PEM)], signed.to_der, OpenSSL::Cipher::Cipher::new("DES3"), OpenSSL::PKCS7::BINARY).to_s.gsub("\n", "")  
  end
end
