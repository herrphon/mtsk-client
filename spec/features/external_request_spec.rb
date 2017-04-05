RSpec.describe 'External request' do

  it 'should throw an exception when accessed' do
    uri = URI('http://test.de')

    expect{ Net::HTTP.get(uri) }.to raise_error(WebMock::NetConnectNotAllowedError)
  end

end
