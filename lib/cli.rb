require "thor"

class Cli < Thor
  def self.options
    @@options
  end

  option :name,     :aliases => :n, :required => true
  option :location, :aliases => :l, :required => true
  option :type,     :aliases => :t, :required => true
  option :radius,   :aliases => :r, :type => :numeric, :default => 2
  option :operator, :aliases => :o, :required => true
  desc 'run', 'run and get price'
  def run
    @@options = options
  end

end


