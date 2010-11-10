require 'spree_core'
require 'pp_website_standard_hooks'

module PpWebsiteStandard
  class Engine < Rails::Engine

    config.autoload_paths += %W(#{config.root}/lib)

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.env.production? ? require(c) : load(c)
      end
      
      # add new events and states to the FSM
=begin
      fsm = Order.state_machines[:state]  
      fsm.events << StateMachine::Event.new(fsm, "fail_payment")
      fsm.events["fail_payment"].transition(:to => 'payment_failure', :from => ['in_progress', 'payment_pending'])
  
      fsm.events << StateMachine::Event.new(fsm, "pend_payment")
      fsm.events["pend_payment"].transition(:to => 'payment_pending', :from => 'in_progress')    
      fsm.after_transition(:to => 'payment_pending', :do => lambda {|order| order.update_attribute(:checkout_complete, true)})  
  
      fsm.events["pay"].transition(:to => 'paid', :from => ['payment_pending', 'in_progress'])
=end
    end

    config.to_prepare &method(:activate).to_proc
  end
end
