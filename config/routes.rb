Rails.application.routes.draw do
  post "paypal/confirm", :to => "paypal#confirm", :method => :post
  get "paypal/confirm", :to => "paypal#confirm", :method => :get
  resources :payment_notifications, :only => [:create]
end
