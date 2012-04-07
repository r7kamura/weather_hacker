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
    it "has empty area table at first" do
      id_by_city   = @client.instance_variable_get(:@id_by_city)
      pref_by_city = @client.instance_variable_get(:@pref_by_city)

      id_by_city.keys.size.should == 0
      pref_by_city.keys.size.should == 0
    end

    it "has area table after call" do
      @client.update_area_table
      id_by_city   = @client.instance_variable_get(:@id_by_city)
      pref_by_city = @client.instance_variable_get(:@pref_by_city)

      id_by_city.keys.size.should_not == 0
      pref_by_city.keys.size.should_not == 0
    end
  end
end
