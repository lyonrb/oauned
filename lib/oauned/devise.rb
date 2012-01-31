require 'devise'
Devise.add_module :oauthable,
  :model => 'oauned/models/oauthable',
  :strategy => true

Devise.setup do |config|
  config.warden do |manager|
    manager.default_strategies(:scope => :user).unshift(:oauthable)
  end
end
