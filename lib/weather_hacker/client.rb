# encoding: UTF-8

module WeatherHacker
  class Client
    class ParseError < StandardError; end

    include HTTParty
    base_uri "http://weather.livedoor.com/forecast/webservice/rest/v1"
    AREA_TABLE_URL = "http://weather.livedoor.com/forecast/rss/forecastmap.xml"

    def initialize
      @pref_by_city = {}
      @id_by_city   = {}
    end

    def get_weather(query)
      get "", :query => query
    end

    # set @pref_by_city and @id_by_city
    def update_area_table
      hash = get AREA_TABLE_URL
      parse_area_table(hash)
    end

    private

    def get(*args)
      self.class.get(*args)
    end

    def parse_area_table(hash)
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
    end

    # Canonical prefecture name for Hokkaido
    # 道東 => 北海道
    # 道央 => 北海道
    # 道南 => 北海道
    # 道北 => 北海道
    def canonical_pref(name)
      name.gsub(/^道.*/, "北海道")
    end
  end
end
