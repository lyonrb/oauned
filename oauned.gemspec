$:.push File.expand_path("../lib", __FILE__)
require 'oauned/version'

Gem::Specification.new do |s|
  s.name = "oauned"
  s.summary = "Oauth Provider"
  s.description = "Rails Engine to be an Oauth Provider"
  s.files = Dir["lib/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.version = Oauned::VERSION
end
