Rails.application.routes.draw do
  # Add your extension routes here
  resources :orders do
    # we're kind of abusing the notion of a restful collection here but we're in the weird position of 
    # not being able to create the payment before sending the request to paypal
    resources :paypal_payments do
      collection do
        post 'successful'
      end
    end
  end
end
