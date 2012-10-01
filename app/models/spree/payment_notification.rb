module Spree
  class PaymentNotification < ActiveRecord::Base
    attr_accessible :params, :order_id, :status, :transaction_id

    belongs_to :order
    serialize :params
        
  end
end