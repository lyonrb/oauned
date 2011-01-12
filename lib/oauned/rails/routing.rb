module ActionDispatch::Routing
  class Mapper
    
    def oauned_routing
      get '/' => 'oauned/oauth#index', :as => 'oauth'
      post '/' => 'oauned/oauth#authorize'
      post '/token' => 'oauned/oauth#token'
    end
  end
end