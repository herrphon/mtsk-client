require_relative 'web_data_scraper'
require 'json'

class Main
  def self.run(params = {name: 'Jet Durlach',
                         location: '48.997,8.45645',
                         radius: 2,
                         gas_type: 'e10',
                         brand: 'JET' })
    result = {}
    begin
      result = WebDataScraper.get_gas_station_data(params)
    rescue Exception => e
      result[:error] = 'ERROR'
      result[:error_message] = e.message
    end

    puts JSON.pretty_generate(result)
  end
end
