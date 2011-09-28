
require './order'
require './strategy'
require './indicator'

BestChanceStrategy = Strategy.new
class << BestChanceStrategy

  def should_order? agent
    return Call.new(agent, 1000)#if serdown(2)
    #return Call.new(agent, 1000) if CurDat.dif < -0.05
  end

  def should_settle? order
    est_per = order.est_per
    0.3 < est_per
  end


end

