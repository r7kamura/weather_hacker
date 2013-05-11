# encoding: UTF-8

class WeatherHacker
  class Client
    include HTTParty

    WEATHER_URL    = "http://weather.livedoor.com/forecast/webservice/json/v1"
    AREA_TABLE_URL = "http://weather.livedoor.com/forecast/rss/primary_area.xml"
    ZIPCODE_URL    = "http://zip.cgis.biz/xml/zip.php"

    # @city_id_by_zipcode is cached
    def initialize
      @city_id_by_zipcode = {}
    end

    # get weather data by zipcode
    def get_weather(zipcode, opts = {})
      city_id  = city_id_by_zipcode(zipcode) or return
      query    = { :city => city_id }.merge(opts)
      hash     = get WEATHER_URL, :query => query
      forecast = get_forecast(hash, opts)

      weather = forecast["telop"]
      max = forecast["temperature"]["max"]
      min = forecast["temperature"]["min"]
      max_celsius = max["celsius"] unless max.nil?
      min_celsius = min["celsius"] unless min.nil?

      {
        "weather"     => weather,
        "temperature" => {
        "max" => max_celsius,
        "min" => min_celsius,
      }}
    rescue ParseError
      nil
    end

    private

    # use HTTParty.get
    def get(*args)
      self.class.get(*args)
    end

    # return forecast hash
    def get_forecast(hash, opts)
      days    = ['today', 'tomorrow', 'dayaftertomorrow']
      day_num = 0
      day_num = days.find_index(opts['day']) unless opts['day'].nil?
      hash['forecasts'][day_num]
    end

    # return city id via zipcode API
    def city_id_by_zipcode(zipcode)
      zipcode = canonical_zipcode(zipcode)
      return unless valid_zipcode?(zipcode)

      @city_id_by_zipcode[zipcode] ||= begin
        hash = info_by_zipcode(zipcode)
        city = canonical_city(hash["city"])
        pref = canonical_pref(hash["state"])
        city_id_by_area(city, pref).to_i
      end
    end

    def canonical_zipcode(zipcode)
      zipcode.to_s.tr("０-９", "0-9").tr("-", "").tr("-", "")
    end

    def valid_zipcode?(zipcode)
      zipcode.match(/^\d{7}$/)
    end

    def city_id_by_area(city, pref)
      WeatherHacker::AreaData::ID_BY_CITY[city] ||
      WeatherHacker::AreaData::ID_BY_CITY[pref] ||
      WeatherHacker::AreaData::ID_BY_PREF[pref]
    end

    # return like following Hash
    # {
    #   "state_kana"   => "ﾄｳｷｮｳﾄ",
    #   "city_kana"    => "ﾐﾅﾄｸ",
    #   "address_kana" => "ｼﾛｶﾈﾀﾞｲ",
    #   "company_kana" => "none",
    #   "state"        => "東京都",
    #   "city"         => "港区",
    #   "address"      => "白金台",
    #   "company"      => "none"
    # }
    def info_by_zipcode(zipcode)
      response = get ZIPCODE_URL, :query => { :zn => zipcode }
      values   = response["ZIP_result"]["ADDRESS_value"]["value"]
      Hash[values.map { |v| v.to_a.flatten }]
    rescue NoMethodError
      raise ParseError, "The zipcode is not supported by API"
    end

    # canonical prefecture name
    # 道東 => 北海道
    # 道央 => 北海道
    # 道南 => 北海道
    # 道北 => 北海道
    def canonical_pref(name)
      name = name.gsub(/^道.*/, "北海道")
      name = name.gsub(/[都道府県]$/, "")
      name
    end

    # canonical city name
    def canonical_city(city)
      city.gsub(/市$/, "")
    end

    # use this wehn you want to update AreaData
    def pref_by_city
      @pref_by_city ||= begin
        update_area_table
        @pref_by_city
      end
    end

    # use this wehn you want to update AreaData
    def id_by_city
      @id_by_city ||= begin
        update_area_table
        @id_by_city
      end
    end

    # set @pref_by_city and @id_by_city
    def update_area_table
      hash = get AREA_TABLE_URL
      parse_area_table(hash)
    end

    # return typical city's id
    def id_by_pref
      @id_by_pref ||= pref_by_city.inject({}) { |hash, item|
        k, v = item
        hash[k] ||= v
        hash
      }
    end

    # parse area table hash of response from Weather API
    def parse_area_table(hash)
      @pref_by_city ||= {}
      @id_by_city   ||= {}
      hash["rss"]["channel"]["source"]["pref"].each do |pref|
        pref_name = canonical_pref(pref["title"])

        cities = [pref["city"]].flatten
        cities.each do |city|
          id    = city["id"].to_i
          title = city["title"]
          @id_by_city[title] = id
          @pref_by_city[title] = pref_name
        end
      end
    rescue
      raise ParseError, "Failed to parse area data from API"
    end

    # Custom Error class to raise in parse response from API
    class ParseError < StandardError; end
  end
end
