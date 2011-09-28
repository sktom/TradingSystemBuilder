
require './historicaldata'

module Indicator

  def serup(n)
    ser n, :<
  end
  def serdown(n)
    ser n, :>
  end
  private
  def ser(n, operator)
    rates = HD.latest(n).map{|record| record.quote}
    n.pred.times do |i|
      return false unless rates[i].open.send(operator, rates[i].close)
    end
    return true
  end


end
