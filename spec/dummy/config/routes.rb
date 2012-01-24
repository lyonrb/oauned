Dummy::Application.routes.draw do
  devise_for :users
  oauned_routing

  scope '/scoped' do
    oauned_routing
  end

  root :to => 'home#index'
end
