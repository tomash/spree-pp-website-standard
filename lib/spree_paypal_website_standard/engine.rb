module SpreePaypalWebsiteStandard
  class Engine < Rails::Engine
    engine_name 'spree_paypal_website_standard'

    config.autoload_paths += %W(#{config.root}/lib)

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../../app/**/*_decorator*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
      # we don't roll like this anymore
      #config.after_initialize do |app|
      #  app.config.spree.payment_methods << Spree::BillingIntegration::PaypalWebsiteStandard
      #end
    end

    initializer "spree.gateway.payment_methods", :after => "spree.register.payment_methods" do |app|
      app.config.spree.payment_methods << Spree::BillingIntegration::PaypalWebsiteStandard
    end

    config.to_prepare &method(:activate).to_proc

  end
end
