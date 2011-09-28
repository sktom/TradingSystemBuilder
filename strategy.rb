
require './indicator'

class Strategy
  include Indicator
  def should_order?
  end
  def should_settle?(order)
  end
end

