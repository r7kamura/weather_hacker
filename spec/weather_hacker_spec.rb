# encoding: UTF-8

require "spec_helper"

describe "WeatherHacker" do
  before do
    @zipcode = "690-0261"
    @weather = WeatherHacker.new
  end

  describe "#initialize" do
    it "should have client attribute" do
      @weather.instance_variable_get(:@client).should_not be_nil
    end
  end

  describe "#today" do
    before do
      @result = @weather.today(@zipcode)
    end
    it "should return weather data on today" do
      @result.should be_kind_of Hash
      @result.should have_key "weather"
      @result.should have_key "temperature"
    end
  end

  describe "#tomorrow" do
    before do
      @result = @weather.tomorrow(@zipcode)
    end
    it "should return weather data on tomorrow" do
      @result.should be_kind_of Hash
      @result.should have_key "weather"
      @result.should have_key "temperature"
    end
  end

  describe "#day_after_tomorrow" do
    before do
      @result = @weather.day_after_tomorrow(@zipcode)
    end
    it "should return weather data on day ofter tomorrow" do
      @result.should be_kind_of Hash
      @result.should have_key "weather"
      @result.should have_key "temperature"
    end
  end
end
