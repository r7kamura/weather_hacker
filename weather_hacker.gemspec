# -*- encoding: utf-8 -*-
require File.expand_path('../lib/weather_hacker/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Ryo NAKAMURA"]
  gem.email         = ["r7kamura@gmail.com"]
  gem.description   = %q{Library for Livedoor Weather Web Service}
  gem.summary       = %q{Weather Forecaster via Livedoor Weather Web Service}
  gem.homepage      = "http://r7kamura.github.com/weather_hacker/"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "weather_hacker"
  gem.require_paths = ["lib"]
  gem.version       = WeatherHacker::VERSION

  gem.add_dependency 'rake', '>= 0.9.2'
  gem.add_dependency "httparty"
  gem.add_dependency "awesome_print"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "simplecov"
  gem.add_development_dependency "simplecov-vim"
end
