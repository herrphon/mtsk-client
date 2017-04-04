#!/usr/bin/env ruby

require 'json'

require_relative '../lib/cli'
require_relative '../lib/web_data_scraper'

Cli.start(ARGV)
options = Cli.options

gas_station_data = {
    name:     options['name'],
    location: options['location'],
    radius:   options['radius'],
    gas_type: options['type'],
    operator: options['operator']
}


begin
  gas_station_data = WebDataScraper.update_gas_station_data(gas_station_data)
rescue Exception => e
  gas_station_data[:error] = "ERROR"
  gas_station_data[:error_message] = e.message
end

puts gas_station_data.to_json

