#!/home/avonrent/ruby2.0/bin/ruby
##!/usr/bin/env ruby

require 'pp'
require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'json'
require 'logger'

class Sprit_Monitor_Url
  class MyHash < Hash
    class Option
      def initialize(name, value)
        @name = "tx_spritpreismonitor_pi1[searchRequest][#{name}]"
        @name = "tx_spritpreismonitor_pi1%5BsearchRequest%5D%5B#{name}%5D"
        @value = value
      end
      def to_s
        "#{@name}=#{@value}"
      end
    end # Option

    def []=(name, value)
      option = Option.new(name, value)
      super(name, option)
    end
  end # MyHash

  attr_accessor :option
  def initialize(gas_station, gas_type)
    @base_url = "http://www.spritpreismonitor.de/suche/?"
    @option = MyHash.new
    @option['plzOrtGeo'] = gas_station[:location]
    @option['umkreis'] = gas_station[:radius]
    @option['kraftstoffart'] = gas_type
    @option['tankstellenbetreiber'] = gas_station[:operator]
  end
  def to_s
    @base_url + @option.values.join('&')
  end
end

class Sprit_Monitor
  class Gas_Station < Hash
    def initialize(name, location, operator, radius)
      self[:name] = name
      self[:location] = location
      self[:operator] = operator
      self[:radius] = radius || 2
      self[:prices] = {}
    end
  end

  attr_accessor :gas_stations, :gas_types

  def initialize(gas_stations = nil, gas_types = nil)
    @gas_stations = gas_stations || []
    @gas_types = gas_types || [:diesel, :e10, :e5]
  end

  def add_gas_station(name, location, operator = nil, radius = nil)
    @gas_stations << Gas_Station.new(name, location, operator, radius)
  end

  def update_all_gas_stations
    result = {}
    @gas_stations.each { |gas_station|
      $log.info("Updating gas station #{gas_station[:name]}")
      update_gas_station(gas_station)
    }
  end

  def update_gas_station(gas_station)
    @gas_types.each { |gas_type|
      sprit_monitor_url = Sprit_Monitor_Url.new(gas_station, gas_type)
      url = sprit_monitor_url.to_s
      doc = Nokogiri::HTML(open(url))
      js_source = doc.css('div.content div.content-box script')[0].content
      js_data = Sprit_Monitor.get_data_from_js_source(js_source)
      gas_station[:prices][gas_type] = js_data[gas_type.to_s]
      
      ['laengengrad', 'breitengrad', 'strasse', 'plz', 'ort'].each { |key|
        gas_station[key.to_sym] = js_data[key]
      }
    }
  end

  def self.get_data_from_js_source(js_source)
    json_string = js_source.match(/.*var\ spmResult\ =\ (.*);.*/)[1]
    json = JSON.parse(json_string)
    if json.size > 1
      $log.info("Found more than one location - using first entry")
      # $log.debug(json)
    end
    return json[0]
  end
end




# stupid test - should test for some more stuff....
def test_data_from_js_source
  js_source = "\n            <!--\n                var spmResult = " +
              "[{\"mtsk_id\":\"51D4B432A0951AA0E10080009459E03A\"," +
              "\"name\":\"JET KARLSRUHE KILLISFELDSTR. 32\",\"marke\":\"JET\"," + 
              "\"laengengrad\":\"8.45645\",\"breitengrad\":\"48.997\"," +
              "\"strasse\":\"KILLISFELDSTR. 32\",\"hausnr\":\"\"," + 
              "\"plz\":\"76227\",\"ort\":\"KARLSRUHE\"," +
              "\"datum\":\"2013-10-28 16:41:37\",\"e5\":\"1.479\","+
              "\"entfernung\":\"1.62\"}];\n                var MySpmConfig " +
              "= new SpmConfig(\"e5\", 48.9881, 8.47434, 2, \"http://www." + 
              "spritpreismonitor.de/\", false, \"28.10.13 18:03:12\");\n" + 
              "            -->\n            "
  data = Sprit_Monitor.get_data_from_js_source(js_source)
  raise 'something is wrong' unless data['e5'] == '1.479'
end
test_data_from_js_source



class Round_Robin_Database
  attr_reader :gas_station, :db_file, :rrdtool
  def initialize(gas_station, rrdtool)
    @gas_station = gas_station
    @rrdtool = rrdtool
    @gas_station_name = gas_station[:name].tr(' ', '_')
    @db_file = "#{File.dirname(__FILE__)}/#{@gas_station_name}.rrd"
    @chart = "#{File.dirname(__FILE__)}/#{@gas_station_name}.png"
    create_rrd_db() unless File.exists?(@db_file)
  end

  def create_rrd_db()
    $log.info("Creating #{@db_file}")
    command = "#{@rrdtool} create #{@db_file} " +
            "--step 1800 " +
            "DS:diesel:GAUGE:2000:1.00:2.00 " +
            "DS:e5:GAUGE:2000:1.00:2.00 " +
            "DS:e10:GAUGE:2000:1.00:2.00 " +
            "RRA:MAX:0.5:1:2880 "
    puts `#{command}`
  end

  def update_rrd_db()
    $log.info("Updating #{@db_file}")
    price = @gas_station[:prices]
    command = "#{@rrdtool} update #{@db_file} " + 
              "N:#{price[:diesel]}:#{price[:e5]}:#{price[:e10]}"
    puts `#{command}`
  end

  def plot_rrd_graphics(days = 7)
    puts "plotting #{@db_file}"
    command = "#{@rrdtool} graph #{@chart} " +
              "--width #{days * 1000} --height 600 " +
              "--end now --start end-#{days}d " +
              "DEF:diesel=#{db_file}:diesel:MAX " +
              "DEF:e5=#{db_file}:e5:MAX " +
              "DEF:e10=#{db_file}:e10:MAX " +
              "LINE1:diesel#FF0000:diesel " +
              "LINE2:e5#00FF00:e5 " +
              "LINE3:e10#0000FF:e10 "
    puts `#{command}`
  end
end



# global logger
$log = Logger.new(STDOUT)
rrdtool = '/opt/rrdtool-1.4.8/bin/rrdtool'

sprit_monitor = Sprit_Monitor.new
sprit_monitor.add_gas_station('Jet Durlach', '48.997,8.45645', 'JET')
sprit_monitor.add_gas_station('Jet Pforzheim', 75175, 'JET')

pp sprit_monitor.update_all_gas_stations

sprit_monitor.gas_stations.each { |gas_station|
  rrd = Round_Robin_Database.new(gas_station, rrdtool)
  rrd.update_rrd_db
  rrd.plot_rrd_graphics
}



