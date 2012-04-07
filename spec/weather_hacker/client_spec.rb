require "spec_helper"

describe "WeatherHacker::Client" do
  before do
    @client = WeatherHacker::Client.new
  end

  it do
    @client.should be_true
  end

  describe "#get_weather" do
    it "get parsed weather data in Hash" do
      hash = @client.get_weather(:city => 113)
      hash.should be_kind_of Hash
    end
  end

  describe "#get_area_table" do
    it "get area id table" do
      hash = @client.get_area_table
      hash.should be_kind_of Hash
    end
  end
end
