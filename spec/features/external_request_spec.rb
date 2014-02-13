require 'spec_helper'

feature 'External request' do

  it 'should throw an exception when accessed' do
    uri = URI('http://test.de')

    request = Net::HTTP.get(uri)

    expect{response}.to raise_error

  end

end
