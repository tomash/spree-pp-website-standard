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

        unless params.has_key?('encrypted')
          Spree::PaypalWebsiteStandard::Config.encrypted = false
        end

        redirect_to admin_paypal_preferences_path
      end

    end
  end
end