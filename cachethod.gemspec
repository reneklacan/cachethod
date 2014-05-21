$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "cachethod/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "cachethod"
  s.version     = Cachethod::VERSION
  s.authors     = ["Rene Klacan"]
  s.email       = ["rene@klacan.sk"]
  s.homepage    = "https://github.com/reneklacan/cachethod"
  s.summary     = "Rails plugin for caching model methods"
  s.description = "Rails plugin for caching model methods"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.required_ruby_version = ">= 1.9"
  s.add_dependency "rails", ">= 3"
  s.add_development_dependency "rdoc", "~> 4"
end
