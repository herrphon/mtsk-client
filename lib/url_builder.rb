require 'cgi'
require 'uri'

class UrlBuilder
  def initialize(params = { name: 'Jet Durlach',
                            location: '48.997,8.45645',
                            radius: 2,
                            gas_type: 'e10',
                            operator: 'JET' })

    @query_options = {}
    @query_options["tx_spritpreismonitor_pi1[searchRequest][#{name}]"] = nil
    @query_options['plzOrtGeo'] = params[:location]
    @query_options['umkreis'] = params[:radius]
    @query_options['kraftstoffart'] = params[:gas_type]
    @query_options['tankstellenbetreiber'] = params[:operator]
  end

  def to_query( input = { key: value } )
    input.map {|k, v|
      if v
        "#{k} = #{CGI::escape v}"
      else
        CGI::escape(k)
      end
    }.join("&")
  end


  #  http://www.spritpreismonitor.de/suche/?
  #    tx_spritpreismonitor_pi1[searchRequest][#{name}]
  #
  #    tx_spritpreismonitor_pi1%5BsearchRequest%5D%5B#{name}%5D
  def to_s
    URI::HTTP.build(host: 'www.spritpreismonitor.de',
                    path: '/suche/',
                    query: to_query(@query_options)).to_s
  end

end