require 'nokogiri'
require 'open-uri'
require 'json'

require_relative 'url_builder'


class WebDataScraper
  def self.update_gas_station_data(gas_station_data)
    url = UrlBuilder.new(gas_station_data).to_s
    doc = Nokogiri::HTML(open(url))

    js_source = doc.css('div.content div.content-box script')[1].content

    js_data = WebDataScraper.get_data_from_js_source(js_source)

    require 'pp'
    pp js_data

    gas_station_data = {}
    gas_station_data[:price] = js_data[gas_station_data[:gas_type]].to_f

    gas_station_data[:latitude] = js_data['breitengrad'].to_f
    gas_station_data[:longitude] = js_data['laengengrad'].to_f

    gas_station_data[:street] = js_data['strasse']
    gas_station_data[:city] = js_data['ort']
    gas_station_data[:zip_code] = js_data['plz'].to_i

    return gas_station_data
  end

  def self.get_data_from_js_source(js_source)
    json_string = js_source.match(/.*var\ spmResult\ =\ (.*);.*/)[1]
    json = JSON.parse(json_string)
    if json.size > 1
      if $log
        $log.info("Found more than one location - using first entry")
        $log.debug(json)
      end
    end
    return json[0]
  end
end

