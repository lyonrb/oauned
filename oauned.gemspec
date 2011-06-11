# Provide a simple gemspec so you can easily use your enginex
# project in your rails apps through git.
Gem::Specification.new do |s|
  s.name = "oauned"
  s.summary = "Oauth Provider"
  s.description = "Rails Engine to be an Oauth Provider"
  s.files = Dir["lib/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.version = "0.0.2"
end