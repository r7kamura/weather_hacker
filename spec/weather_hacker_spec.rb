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

  end
end
