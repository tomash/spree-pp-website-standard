require 'spec_helper'

describe Spree::BillingIntegration::PaypalWebsiteStandard do

  before :each do
    @pws = Spree::BillingIntegration::PaypalWebsiteStandard.new
  end

  it "has required fields" do
    ["account_email", "success_url", "paypal_url", "certificate_id"].each do |key|
      @pws.send("preferred_#{key}=", 'test')
      @pws.send("preferred_#{key}").should eq 'test'
    end
  end

  it "be compatible with spree gateway API" do
    @pws.payment_profiles_supported?.should be_false
  end

end
