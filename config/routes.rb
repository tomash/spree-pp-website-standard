Spree::Core::Engine.routes.prepend do
  post "paypal/confirm", :to => "paypal#confirm", :method => :post
  get "paypal/confirm", :to => "paypal#confirm", :method => :get
  resources :payment_notifications, :only => [:create]

  namespace :admin do
    resources :paypal_preferences do
    end
  end

end