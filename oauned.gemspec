$:.push File.expand_path("../lib", __FILE__)
require 'oauned/version'

Gem::Specification.new do |s|
  s.name = "oauned"
  s.summary = "Oauth Provider"
  s.description = "Rails Engine to be an Oauth Provider"
  s.files = Dir["app/**/*", "lib/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.authors = ["Damien MATHIEU"]
  s.version = Oauned::VERSION

  s.add_dependency('rails', "~> 3.1")
  s.add_dependency('devise', ">= 1.5")
end
