require 'cgi'
require 'uri'

class UrlBuilder
  def initialize(params = { name: 'Jet Durlach',
                            location: '48.997,8.45645',
                            radius: 2,
                            gas_type: 'e10',
                            brand: 'JET' })

    @query_options = {}
    @query_options['plzOrtGeo'] = params[:location]
    @query_options['umkreis'] = params[:radius].to_s
    @query_options['kraftstoffart'] = params[:gas_type]
    @query_options['tankstellenbetreiber'] = params[:brand]
  end


  def to_s
    URI::HTTP.build(host: 'www.spritpreismonitor.de',
                    path: '/suche/',
                    query: to_query(@query_options)).to_s
  end


  def to_query( input = { key: value } )
    # key: tx_spritpreismonitor_pi1[searchRequest][#{name}]
    input.map {|k, v|
      key = CGI::escape "tx_spritpreismonitor_pi1[searchRequest][#{k}]"
      value = CGI::escape v
      "#{key}=#{value}"
    }.join('&')
  end

end