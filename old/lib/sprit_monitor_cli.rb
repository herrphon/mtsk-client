require 'thor'
require_relative 'main'

class SpritMonitorCli < Thor
  package_name "Sprit Monitor"

  desc 'get', 'get price'
  method_option :name,
                :aliases => '-n',
                :required => true,
                :desc => 'Name'
  method_option :brand,
                :aliases => '-b',
                :required => true,
                :desc => 'Brand'
  method_option :type,
                :aliases => :t,
                :required => true,
                :desc => 'Type'
  method_option :location,
                :aliases => '-l',
                :required => true,
                :desc => 'Location'
  method_option :radius,
                :aliases => :r,
                :type => :numeric,
                :default => 2,
                :desc => 'Radius'
  def get
    gas_station_data = {
        name:     options['name'],
        location: options['location'],
        radius:   options['radius'],
        gas_type: options['type'],
        brand: options['brand']
    }

    Main.run(gas_station_data)
  end

  # exit with exit code != 0 when error occurs
  def self.exit_on_failure?
    true
  end
end


