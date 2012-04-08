[![Build Status](https://secure.travis-ci.org/r7kamura/weather_hacker.png?branch=master)](http://travis-ci.org/r7kamura/weather_hacker)

# WeatherHacker

Library for [Livedoor Weather Web Service](http://weather.livedoor.com/weather_hacks/webservice.html)

## Installation

Add this line to your application's Gemfile:

    gem 'weather_hacker'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install weather_hacker

## Usage
~~~
require "weather_hacker"

zipcode = "690-0261"
weather = WeatherHacker.new(zipcode)

weather.on(Date.today)
#=> {
#         "weather" => "晴れ",
#     "temperature" => { "max" => "18", "min" => "1" }
#   }

weather.today
#=> {
#         "weather" => "晴れ",
#     "temperature" => { "max" => "18", "min" => "1" }
#   }

weather.tomorrow
#=> {
#         "weather" => "晴時々曇",
#     "temperature" => { "max" => 21, "min" => 9 }
#   }

weather.day_after_tomorrow
#=> {
#         "weather" => "晴時々曇",
#     "temperature" => { "max" => nil, "min" => nil }
#   }
~~~

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
