require_relative 'web_data_scraper'
require 'json'

class Main
  def self.run(gas_station_data)
    begin
      gas_station_data = WebDataScraper.get_gas_station_data(gas_station_data)
    rescue Exception => e
      puts e
      puts e.backtrace
      exit 0

      gas_station_data[:error] = "ERROR"
      gas_station_data[:error_message] = e.message
    end

    puts gas_station_data.to_json
  end
end
