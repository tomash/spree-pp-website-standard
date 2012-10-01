module Spree
  module Admin
    class PaypalPreferencesController < Spree::Admin::BaseController

      def index
        @pp_config = Spree::PaypalWebsiteStandard::Config
      end

      def create
        params.each do |name, value|
          next unless Spree::PaypalWebsiteStandard::Config.has_preference? name
          Spree::PaypalWebsiteStandard::Config[name] = value
        end

        # Setting the success URL within the controller to prevent error.
        # If the confirm url get change it has to be reflected here.
        Spree::PaypalWebsiteStandard::Config[:success_url] = Spree::Config.site_url + "/paypal/confirm"

        unless params.has_key?('encrypted')
          Spree::PaypalWebsiteStandard::Config.encrypted = false
        end

        redirect_to admin_paypal_preferences_path
      end

    end
  end
end