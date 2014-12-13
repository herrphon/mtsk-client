require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'json'

require 'url_builder'


class WebDataScraper
  def self.update_gas_station_data(gas_station_data)
    url = UrlBuilder.new(gas_station_data).to_s
    doc = Nokogiri::HTML(open(url))

    js_source = doc.css('div.content div.content-box script')[1].content
    js_data = WebDataScraper.get_data_from_js_source(js_source)

    gas_station_data[:price] = js_data[gas_station_data[:gas_type]].to_f

    ['laengengrad', 'breitengrad'].each { |key|
      gas_station_data[key.to_sym] = js_data[key].to_f
    }

    ['strasse', 'ort'].each { |key|
      gas_station_data[key.to_sym] = js_data[key]
    }
    gas_station_data[:plz] = js_data['plz'].to_i

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

