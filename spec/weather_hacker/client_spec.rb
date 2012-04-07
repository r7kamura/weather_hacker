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

  describe "#update_area_table" do
    it "set area table" do
      @client.update_area_table
      @client.instance_variable_get(:@id_by_city).should be_kind_of Hash
      @client.instance_variable_get(:@pref_by_city).should be_kind_of Hash
    end
  end
end
