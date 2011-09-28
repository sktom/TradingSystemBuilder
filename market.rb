
Market = Object.new
class << Market

  class OrderList < Array
  end
  class OrderBoard < OrderList
    def check
      contracted = Array.new
      delete_if do |order|
        if order.contract
          contracted << order
        else
          false
        end
      end
      contracted
    end
  end
  class Position < OrderList
    def check
      delete_if do |order|
        order.settle
      end
    end
  end

  def init
    @order_board = OrderBoard.new
    @position = Position.new
  end

  def check
    @position.check
    @order_board.check.each do |contracted|
      @position << contracted
    end
  end

  def order order
    return if check_order(order)
    @order_board << order
  end

  def estimate
    est = 0
    @position.each do |pos|
      est += pos.est
    end
    est
  end

  private
  def check_order order
    #@order_board.count + @position.count > 9
  end

  #def rate
    #File.open('rate.asp') do |f|
      #f.pos = 0
      #f.readpartial(30)[-6, 6].to_f
    #end
  #end


end

