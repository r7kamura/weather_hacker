require "spec_helper"

describe "WeatherHacker::Client" do
  before do
    @client = WeatherHacker::Client.new
  end

  it do
    @client.should be_true
  end
end
