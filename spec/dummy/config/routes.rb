Rails.application.routes.draw do
  mount SpreePaypalWebsiteStandard::Engine => "/"
end
