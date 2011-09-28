
require './historicaldata'

class Order
  attr :rate_in, :rate_out
  attr :time_in, :time_out

  def initialize(owner, volume = 1000)
    @volume = volume
    @owner = owner
  end

  def contract
    throw :double_entry if @rate_in
    record = HD.latest
    @time_in = record.time
    @rate_in = kind_of?(Call) ? record.ask : record.bid
    return true
  end
  def settle
    throw :double_settlement if @rate_out
    return unless @owner.settle?(self)
    record = HD.latest
    @rate_out = kind_of?(Call) ? record.bid : record.ask
    @time_out = record.time
    
    income = (@rate_out - @rate_in) * @volume * (kind_of?(Call) ? 1 : -1)
    @owner.instance_exec(income) do |inc|
      @resource += inc
    end
    return true
  end

  def est_per
    est / @volume
  end

end

class Call < Order
  def est
    throw :estimation_before_join unless @rate_in
    (HD.latest.ask - @rate_in) * @volume
  end
end
class Put < Order
  def est
    throw :estimation_before_join unless @rate_in
    (@rate_in - HD.latest.bid) * @volume
  end
end

