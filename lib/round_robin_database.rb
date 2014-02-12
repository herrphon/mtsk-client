
class Round_Robin_Database
  attr_reader :gas_station, :db_file, :rrdtool
  
  def initialize(gas_station, rrdtool)
    @gas_station = gas_station
    @rrdtool = rrdtool
    @gas_station_name = gas_station[:name].tr(' ', '_')
    @db_file = "#{File.dirname(__FILE__)}/#{@gas_station_name}.rrd"
    @chart = "#{File.dirname(__FILE__)}/#{@gas_station_name}.png"
    create_rrd_db() unless File.exists?(@db_file)
  end

  def create_rrd_db()
    $log.info("Creating #{@db_file}")
    command = "#{@rrdtool} create #{@db_file} " +
            "--step 1800 " +
            "DS:diesel:GAUGE:2000:1.00:2.00 " +
            "DS:e5:GAUGE:2000:1.00:2.00 " +
            "DS:e10:GAUGE:2000:1.00:2.00 " +
            "RRA:MAX:0.5:1:2880 "
    puts `#{command}`
  end

  def update_rrd_db()
    $log.info("Updating #{@db_file}")
    price = @gas_station[:prices]
    command = "#{@rrdtool} update #{@db_file} " + 
              "N:#{price[:diesel]}:#{price[:e5]}:#{price[:e10]}"
    puts `#{command}`
  end

  def plot_rrd_graphics(days = 7)
    puts "plotting #{@db_file}"
    command = "#{@rrdtool} graph #{@chart} " +
              "--width #{days * 1000} --height 600 " +
              "--end now --start end-#{days}d " +
              "DEF:diesel=#{db_file}:diesel:MAX " +
              "DEF:e5=#{db_file}:e5:MAX " +
              "DEF:e10=#{db_file}:e10:MAX " +
              "LINE1:diesel#FF0000:diesel " +
              "LINE2:e5#00FF00:e5 " +
              "LINE3:e10#0000FF:e10 "
    puts `#{command}`
  end
end