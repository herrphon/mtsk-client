#!/usr/bin/env ruby

require 'pp'
require 'logger'
require 'json'

# add lib dir to path
lib_dir = File.expand_path( File.join( File.dirname(__FILE__), 'lib' ) )
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'opt_parser'
require 'web_data_scraper'


def get_commandline_options
  parser = UTIL::OptParser.new
  parser.option(:name, 'Optional, specify a name of the gas station.', String)
  parser.option(:location, 'Specify the location via zip code or coordinates e.g. 76543 or 45.123,10.456.', String)
  parser.option(:operator, 'Specify the operator name e.g. JET or AGIP.', String)
  parser.option(:type, 'Optional, specify the type of gas (diesel, e5, e10). Default is e5.', String)
  parser.option(:radius, 'Optional, specify radius in km. Default is 2.', Integer)
  parser.option(:log, 'Optional, active logging')
  parser.parse!

  unless parser.result[:location] and parser.result[:operator]
    puts parser
    exit 0
  end

  case parser.result[:type]
    when 'diesel'
      parser.result[:gas_type] = 'diesel'
    when 'e10'
      parser.result[:gas_type] = 'e10'
    else
      parser.result[:gas_type] = 'e5'
  end

  parser.result[:radius] = 2 unless parser.result[:radius]

  if parser.result[:log]
    $log = Logger.new(STDOUT)
  end

  return parser.result
end



if __FILE__ == $0
  option = get_commandline_options

  gas_station_data = {
      :name => option[:name],
      :location => option[:location],
      :radius => option[:radius],
      :gas_type => option[:gas_type],
      :operator => option[:operator]
  }

  begin
    gas_station_data = WebDataScraper.update_gas_station_data(gas_station_data)
  rescue Exception => e
    gas_station_data[:error] = "ERROR"
    gas_station_data[:error_message] = e.message
  end

  puts gas_station_data.to_json
end

