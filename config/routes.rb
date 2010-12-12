Rails.application.routes.draw do
  post "paypal/confirm", :to => "paypal#confirm", :method => :post
  resources :payment_notifications, :only => [:create]
end
