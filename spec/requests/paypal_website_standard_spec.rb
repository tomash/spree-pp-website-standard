require 'spec_helper'
=begin
describe "Paypal Website Standard checkout" do
  before do
    FactoryGirl.create(:shipping_method, :zone => Spree::Zone.global)
    FactoryGirl.create(:payment_method, :environment => 'test')
    @product = FactoryGirl.create(:product, :name => "RoR Mug")
    sign_in_as! FactoryGirl.create(:user)

    FactoryGirl.create(:paypal_website_standard_payment_method)
  end

  let!(:address) { FactoryGirl.create(:address, :state => Spree::State.first) }

  it "should display paypal button", :js => true do
    visit spree.product_path(@product)

    click_button "Add To Cart"
    click_button "Checkout"

    str_addr = "bill_address"
    select "United States", :from => "order_#{str_addr}_attributes_country_id"
    ['firstname', 'lastname', 'address1', 'city', 'zipcode', 'phone'].each do |field|
      fill_in "order_#{str_addr}_attributes_#{field}", :with => "#{address.send(field)}"
    end
    select "#{address.state.name}", :from => "order_#{str_addr}_attributes_state_id"
    check "order_use_billing"
    fill_in 'order[email]', :with => 'spree@example.com'
    click_button "Save and Continue"

    #delivery
    click_button "Save and Continue"

    choose "Paypal"
    page.should have_selector('input#ppx')
    click_button "Save and Continue"

    current_path.should match /\A\/orders\/[A-Z][0-9]{9}\/checkout\/paypal_payment\z/
  end
end
=end