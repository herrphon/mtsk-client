
class UrlBuilder
  attr_accessor :option

  def initialize(gas_station_data)
    @base_url = "http://www.spritpreismonitor.de/suche/?"
    @option = MyHash.new
    @option['plzOrtGeo'] = gas_station_data[:location]
    @option['umkreis'] = gas_station_data[:radius]
    @option['kraftstoffart'] = gas_station_data[:gas_type]
    @option['tankstellenbetreiber'] = gas_station_data[:operator]
  end

  def to_s
    @base_url + @option.values.join('&')
  end

  private
    class MyHash < Hash
      class Option
        def initialize(name, value)
          # @name = "tx_spritpreismonitor_pi1[searchRequest][#{name}]"
          @name = "tx_spritpreismonitor_pi1%5BsearchRequest%5D%5B#{name}%5D"
          @value = value
        end
        def to_s
          "#{@name}=#{@value}"
        end
      end

      def []=(name, value)
        option = Option.new(name, value)
        super(name, option)
      end
    end
end