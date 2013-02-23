# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = "rack-matrix_params"
  gem.version       = open('./VERSION').read
  gem.authors       = ["JP Hastings-Spital","Michal Fojtik"]
  gem.email         = ["jphastings@gmail.com"]
  gem.description   = %q{Rack middleware that populates the params variable with the contents of matrix parameters in a URL}
  gem.summary       = %q{Allows the use of matrix URLs in a Rack environment}
  gem.homepage      = "http://github.com/jphastings/rack-matrix_params"

  gem.files         = `git ls-files`.split($/)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'rack'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'bundler'
  gem.add_development_dependency 'rack-test'
end
