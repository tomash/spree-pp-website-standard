require 'spec_helper'

describe Order do

  context "instance methods" do
    before(:all) do
      @order = Factory(:order_with_totals)
    end

    it "should return true" do
      true.should eql true
    end
  end
end