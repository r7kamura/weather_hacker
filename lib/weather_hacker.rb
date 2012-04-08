require "httparty"

require "weather_hacker/version"
require "weather_hacker/client"

class WeatherHacker
  def initialize(zipcode)
    @zipcode = zipcode
    @client  = Client.new
  end

  # define these methods
  # * WeatherHacker#today(zipcode)
  # * WeatherHacker#tomorrow(zipcode)
  # * WeatherHacker#dayaftertomorrow(zipcode)
  [:today, :tomorrow, :day_after_tomorrow].each do |day|
    define_method(day) do
      @client.get_weather(@zipcode, :day => day.to_s.tr("_", ""))
    end
  end

  # return weather data on the received date
  # if the date is not supported, return nil
  def on(date)
    now = Date.today
    {
      now     => today,
      now + 1 => tomorrow,
      now + 2 => day_after_tomorrow,
    }[date]
  end
end
