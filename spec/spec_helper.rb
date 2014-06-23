require 'simplecov'
require 'capybara/rspec'
require 'webmock/rspec'
require 'coveralls'

Coveralls.wear!

WebMock.disable_net_connect!(allow_localhost: true)


SimpleCov.start do
  add_filter '/spec'
  add_filter '/config'
end

RSpec.configure do |config|
  # Use the specified formatter
  config.formatter = :documentation # :progress, :html, :textmate
end



def add_dir_to_library_path(directory)
  lib_dir = File.expand_path( File.join( File.dirname(__FILE__), directory ) )
  $LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)
end

add_dir_to_library_path('../../lib')


