require "httparty"

require "weather_hacker/version"
require "weather_hacker/client"

class WeatherHacker
  def initialize
    @client = Client.new
  end
end
