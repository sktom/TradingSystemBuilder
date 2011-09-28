require 'rubygems'
require 'sqlite3'
require './market'
require './agent'
require './historicaldata'

TestEnv = Object.new
class << TestEnv

  def run agent
    init
    @log = Array.new
    while HD.index < @index_max
      Market.check
      agent.act
      HD.shift
      @log << [HD.latest.time, agent.resource, agent.resource + Market.estimate]
    end
  end

  def output
    File.open('res', 'w') do |f|
      @log.each do |record|
        time, real, fair = record
        f.puts "#{time.year}/#{time.month}/#{time.day}, #{real}, #{fair}"
      end
    end
    `gnuplot -persist -e "
    set xdata time;
    set timefmt '%Y/%m/%d';
    plot 'res' u 1:2 title 'real value' w l, 'res' u 1:3 title 'fair value' w l"`
  end

  private
  def init
    @db = SQLite3::Database.new('HistoricalData')
    HD.init @db
    Market.init
    @agent = Agent.new

    @index_max = @db.execute("select max(id) from usdjpy")[0][0]
  end


end

