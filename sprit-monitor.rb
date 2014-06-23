#!/home/avonrent/ruby2.0/bin/ruby
##!/usr/bin/env ruby

def add_dir_to_library_path(directory)
  lib_dir = File.expand_path( File.join( File.dirname(__FILE__), directory ) )
  $LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)
end

add_dir_to_library_path('lib')

require 'pp'
require 'logger'

require 'web_data_scraper'
require 'url_builder'
require 'round_robin_database'


# global logger
$log = Logger.new(STDOUT)
rrdtool = '/opt/rrdtool-1.4.8/bin/rrdtool'

sprit_monitor = WebDataScraper.new
sprit_monitor.add_gas_station('Jet Durlach', '48.997,8.45645', 'JET')
sprit_monitor.add_gas_station('Jet Pforzheim', 75175, 'JET')

pp sprit_monitor.update_all_gas_stations

sprit_monitor.gas_stations.each { |gas_station|
  pp gas_station
  
  # rrd = Round_Robin_Database.new(gas_station, rrdtool)
  # rrd.update_rrd_db
  # rrd.plot_rrd_graphics
}



