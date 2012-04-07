# -*- encoding: utf-8 -*-
require File.expand_path('../lib/weather_hacker/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Ryo NAKAMURA"]
  gem.email         = ["r7kamura@gmail.com"]
  gem.description   = %q{Library for Livedoor Weather Web Service}
  gem.summary       = %q{Weather Forecaster via Livedoor Weather Web Service}
  gem.homepage      = "https://github.com/r7kamura/weather_hacker"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "weather_hacker"
  gem.require_paths = ["lib"]
  gem.version       = WeatherHacker::VERSION

  gem.add_dependency 'rake', '>= 0.9.2'
  gem.add_dependency "httparty"
  gem.add_development_dependency "rspec"
end
