require 'mtsk-client/version'
require 'mtsk-client/url_builder'
require 'mtsk-client/web_data_scraper'

# Add requires for other files you add to your project here, so
# you just need to require this one file in your bin file

require 'json'


module MtskClient
  def self.run(params = { name: 'Jet Durlach',
                          location: '48.997,8.45645',
                          radius: 2,
                          gas_type: 'e10',
                          brand: 'JET' })
    begin
      puts JSON.pretty_generate WebDataScraper.get_gas_station_data(params)
    rescue => e
      puts JSON.pretty_generate error: 'ERROR', error_message: e.message
    end

  end
end
