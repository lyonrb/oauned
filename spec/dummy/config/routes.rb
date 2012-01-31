Dummy::Application.routes.draw do
  devise_for :users
  oauned_routing

  scope '/scoped' do
    oauned_routing
  end

  get '/me' => 'home#me'

  root :to => 'home#index'
end
