require 'nokogiri'
require 'open-uri'
require 'json'

require_relative 'url_builder'


class WebDataScraper
  def self.get_gas_station_data(params = {name: 'Jet Durlach',
                                          location: '48.997,8.45645',
                                          radius: 2,
                                          gas_type: 'e10',
                                          brand: 'JET' })
    url = UrlBuilder.new(params).to_s
    doc = Nokogiri::HTML(open(url))

    js_source = doc.css('div.content div.content-box script')[1].content
    js_data = get_data_from_js_source(js_source)

    result = {}
    result[:name] = params[:name] if params[:name]
    result[:mtsk_id] = js_data['mtsk_id']
    result[:brand] = js_data['marke']

    result[:type] = params[:gas_type]
    result[:price] = js_data[params[:gas_type]].to_f

    result[:latitude] = js_data['breitengrad'].to_f
    result[:longitude] = js_data['laengengrad'].to_f

    result[:street] = js_data['strasse'].capitalize
    result[:city] = js_data['ort'].capitalize
    result[:zip_code] = js_data['plz'].to_i

    result[:distance] = js_data['entfernung']

    return result
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

