Rails.application.routes.draw do
  resources :payment_notifications, module: 'spree'
  mount Spree::Core::Engine, :at => "/"
end
