require 'spec_helper'

describe Spree::BillingIntegration::PaypalWebsiteStandard do

  before :each do
    @pws = Spree::BillingIntegration::PaypalWebsiteStandard.new
  end

  it "has required fields" do
    ["account_email", "success_url", "paypal_url", "certificate_id"].each do |key|
      @pws.send("preferred_#{key}=", 'test')
      expect(@pws.send("preferred_#{key}")).to eq 'test'
    end
  end

  it "be compatible with spree gateway API" do
    expect(@pws.payment_profiles_supported?).to eq false
  end

end
