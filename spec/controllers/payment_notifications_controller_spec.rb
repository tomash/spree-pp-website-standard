require "spec_helper"

module Spree
  describe PaymentNotificationsController do
    context "when the IPN has an invoice number that is not from a Spree order" do
      let(:ipn) { { :invoice => "INV2-AAAA-BBBB-CCCC-DDDD" } }

      it "doesn't create a PaymentNotification" do
        expect {
          post :create, ipn
        }.to_not change { PaymentNotification.count }
      end

      it "returns a 200 response" do
        post :create, ipn
        response.code.should == "200"
      end
    end
  end
end
