[![Build Status](https://secure.travis-ci.org/r7kamura/weather_hacker.png?branch=master)](http://travis-ci.org/r7kamura/weather_hacker)

# WeatherHacker

Library for [Livedoor Weather Web Service](http://weather.livedoor.com/weather_hacks/webservice.html)

## Installation

```
$ gem install weather_hacker
```

## Usage
### Command
WeatherHacker provides ```weather``` command to watch the weather forecast:

```
$ weather 690-0261
2012-04-15
{
        "weather" => "晴れ",
    "temperature" => {
        "max" => "18",
        "min" => "5"
    }
}

2012-04-16
{
        "weather" => "晴のち曇",
    "temperature" => {
        "max" => "18",
        "min" => "2"
    }
}

2012-04-17
{
        "weather" => "曇り",
    "temperature" => {
        "max" => "17",
        "min" => "9"
    }
}
```

### Example
Here's an example script to watch the weather forecast:

```ruby
# forecast.rb
require "weather_hacker"
require "yaml"
require "date"

zipcode  = "690-0261"
forecast = WeatherHacker.new(zipcode)

y forecast.on(Date.today)
y forecast.today
y forecast.tomorrow
y forecast.day_after_tomorrow
```

```
$ gem install weather_hacker
$ ruby forecast.rb
---
weather: 晴れ
temperature:
  max: '18'
  min: '5'
---
weather: 晴れ
temperature:
  max: '18'
  min: '5'
---
weather: 晴時々曇
temperature:
  max: '18'
  min: '2'
---
weather: 曇り
temperature:
  max: '17'
  min: '9'
```
