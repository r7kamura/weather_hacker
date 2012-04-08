require "httparty"

require "weather_hacker/version"
require "weather_hacker/client"

class WeatherHacker
  def initialize
    @client = Client.new
  end

  # define these methods
  # * WeatherHacker#today(zipcode)
  # * WeatherHacker#tomorrow(zipcode)
  # * WeatherHacker#dayaftertomorrow(zipcode)
  [:today, :tomorrow, :day_after_tomorrow].each do |day|
    define_method(day) do |zipcode|
      @client.get_weather(zipcode, :day => day.to_s.tr("_", ""))
    end
  end

  def on(date, zipcode)
    now = Date.today
    {
      now     => today(zipcode),
      now + 1 => tomorrow(zipcode),
      now + 2 => day_after_tomorrow(zipcode),
    }[date]
  end
end
