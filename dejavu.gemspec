# -*- encoding: utf-8 -*-
require File.expand_path('../lib/dejavu/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Roger Campos"]
  gem.email         = ["roger@itnig.net"]
  gem.description   = %q{Remember your object after a redirect}
  gem.summary       = %q{Remember your object after a redirect}
  gem.homepage      = "https://github.com/rogercampos/dejavu"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "dejavu"
  gem.require_paths = ["lib"]
  gem.version       = Dejavu::VERSION

  gem.add_dependency "rails", ">= 3.0"
  gem.add_development_dependency "rspec-rails", ">= 2.7"
  gem.add_development_dependency "capybara", ">= 1.1.1"
end
