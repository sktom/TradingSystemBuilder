
require './quote'

class Record
  attr :time, :quote
  @@spread = 0.02
  def ask; @quote.close; end
  def bid; ask - @@spread; end
  def initialize(time, quote)
    @time, @quote = time, quote
  end
end

HD = Object.new
class << HD
  attr :index
  def time; @time; end

  def latest(n = nil)
    return @log.last unless n
    @log[-n..-1]
  end

  def init db
    @db = db
    @index = 0

    @buff_size = 5000
    @time, @quote = get_next
    @next_time, @next_quote = get_next
    @log = Array.new
    50.times do
      @log << Record.new(@time, @quote)
      shift
    end
  end

  def shift
    @time = @next_time
    @old_quote = @quote
    @quote = @next_quote
    @log << Record.new(@time, @quote)
    @next_time, @next_quote = get_next
  end

  def size; size = @db.execute("select max(id) from usdjpy")[0][0]; end

  private
  def get_next
    @index += 1
    @record_buff ||= Array.new
    if @record_buff.empty?
      @record_buff = @db.execute("
        select year, month, day, open, hi, low, close
        from usdjpy where #{@index} <= id and id < #{@index + @buff_size}")
    end
    record = @record_buff.shift
    [Date.new(*record[0..2]), Quote.new(*record[-4..-1])]
  end


end

