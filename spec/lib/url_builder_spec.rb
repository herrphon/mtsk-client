require 'url_builder'

RSpec.describe 'UrlBuilder' do

  it 'should create a valid url' do

    result = UrlBuilder.new({ name: 'Jet Durlach',
                              location: '48.997,8.45645',
                              radius: 2,
                              gas_type: 'e10',
                              operator: 'JET' }).to_s

    # http://www.spritpreismonitor.de/suche/?tx_spritpreismonitor_pi1%5BsearchRequest%5D%5BplzOrtGeo%5D=48.997%2C8.45645&tx_spritpreismonitor_pi1%5BsearchRequest%5D%5Bumkreis%5D=2&tx_spritpreismonitor_pi1%5BsearchRequest%5D%5Bkraftstoffart%5D=e10&tx_spritpreismonitor_pi1%5BsearchRequest%5D%5Btankstellenbetreiber%5D=JET

    expected = 'http://www.spritpreismonitor.de/suche/' +
        '?tx_spritpreismonitor_pi1' + '%5BsearchRequest%5D' + '%5BplzOrtGeo%5D' + '=48.997%2C8.45645' +
        '&tx_spritpreismonitor_pi1' + '%5BsearchRequest%5D' + '%5Bumkreis%5D' + '=2' +
        '&tx_spritpreismonitor_pi1' + '%5BsearchRequest%5D' + '%5Bkraftstoffart%5D' + '=e10' +
        '&tx_spritpreismonitor_pi1' + '%5BsearchRequest%5D' + '%5Btankstellenbetreiber%5D' + '=JET'

    expect(result).to eq(expected)
  end

end