# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  root 'home#index'
  get 'indexajax', :to => 'home#ajaxWeather'
end