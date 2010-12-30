# encoding: UTF-8
Rails.application.routes.draw do
  scope '/oauth' do
    get '/' => 'oauned/oauth#index'
    post '/' => 'oauned/oauth#authorize'
    post '/token' => 'oauned/oauth#token'
  end
  
end
