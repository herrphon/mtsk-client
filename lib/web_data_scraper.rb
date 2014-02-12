require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'json'


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

