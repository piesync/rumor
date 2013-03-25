# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rumor/version'

Gem::Specification.new do |gem|
  gem.name          = "rumor"
  gem.version       = Rumor::VERSION
  gem.authors       = ["Mattias Putman"]
  gem.email         = ["mattias.putman@gmail.com"]
  gem.description   = %q{Rumor}
  gem.summary       = %q{Rumor}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'resque'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'guard'
  gem.add_development_dependency 'guard-minitest'
  gem.add_development_dependency 'mocha'
  gem.add_development_dependency 'rb-fsevent', '~> 0.9'
end
