# encoding: UTF-8

require "date"
require "spec_helper"

describe "WeatherHacker" do
  before do
    @weather = WeatherHacker.new("690-0261")
  end

  shared_examples_for "WeatherResult" do
    it "should have weather data" do
      should be_kind_of Hash
      should have_key "weather"
      should have_key "temperature"
    end
  end

  describe "#initialize" do
    it "should have client attribute" do
      @weather.instance_variable_get(:@client).should_not be_nil
    end
  end

  describe "#today" do
    subject { @weather.today }
    it_should_behave_like "WeatherResult"
  end

  describe "#tomorrow" do
    subject { @weather.today }
    it_should_behave_like "WeatherResult"
  end

  describe "#day_after_tomorrow" do
    subject { @weather.today }
    it_should_behave_like "WeatherResult"
  end

  describe "#on" do
    context "when passed date in unavailable range" do
      subject { @weather.on(Date.new(2000, 1, 1)) }
      it { should be_nil }
    end

    context "when passed date in available range" do
      subject { @weather.on(Date.today) }
      it_should_behave_like "WeatherResult"
    end
  end
end
