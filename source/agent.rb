
require './mystrategy'

class Agent
  attr :resource
  def initialize(resource = 10 ** 6)
    @resource = resource
    @strategy = BestChanceStrategy
  end

  def act
    order = @strategy.should_order? self
    return unless order
    Market.order order
  end

  def settle? order
    @strategy.should_settle? order
  end


end

