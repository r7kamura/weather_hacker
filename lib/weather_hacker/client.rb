# encoding: UTF-8

module WeatherHacker
  class Client
    include HTTParty

    WEATHER_URL    = "http://weather.livedoor.com/forecast/webservice/rest/v1"
    AREA_TABLE_URL = "http://weather.livedoor.com/forecast/rss/forecastmap.xml"
    ZIPCODE_URL    = "http://zip.cgis.biz/xml/zip.php"

    # get weather data by zipcode
    def get_weather(zipcode, opts = {})
      city_id = city_id_by_zipcode(zipcode) or return
      query   = { :city => city_id, :day => :today }.merge(opts)
      hash    = get WEATHER_URL, :query => query

      {
        "weather"     => hash["lwws"]["telop"],
        "temperature" => {
          "max" => hash["lwws"]["temperature"]["max"]["celsius"],
          "min" => hash["lwws"]["temperature"]["min"]["celsius"],
        },
      }
    end

    private

    # use HTTParty.get
    def get(*args)
      self.class.get(*args)
    end

    # set @pref_by_city and @id_by_city
    def update_area_table
      hash = get AREA_TABLE_URL
      parse_area_table(hash)
    end

    # return city id via zipcode API
    def city_id_by_zipcode(zipcode)
      zipcode = zipcode.to_s.tr("０-９", "0-9").tr("-", "").tr("-", "")
      return unless zipcode.match(/^\d{7}$/)

      hash = info_by_zipcode(zipcode)
      city = canonical_city(hash["city"])
      pref = canonical_pref(hash["state"])
      id_by_city[city] || id_by_city[pref] || id_by_pref[pref]
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
    end

    # update area table once
    def pref_by_city
      @pref_by_city ||= begin
        update_area_table
        @pref_by_city
      end
    end

    # update area table once
    def id_by_city
      @id_by_city ||= begin
        update_area_table
        @id_by_city
      end
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
      @pref_by_city = {}
      @id_by_city   = {}

      hash["rss"]["channel"]["source"]["area"].each do |area|
        prefs = [area["pref"]].flatten
        prefs.each do |pref|
          pref_name = canonical_pref(pref["title"])

          cities = [pref["city"]].flatten
          cities.each do |city|
            id    = city["id"].to_i
            title = city["title"]
            @id_by_city[title] = id
            @pref_by_city[title] = pref_name
          end
        end
      end
    rescue
      raise ParseError, "Failed to parse area data from API"
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

    # Custom Error class to raise in parse response from API
    class ParseError < StandardError; end
  end
end
