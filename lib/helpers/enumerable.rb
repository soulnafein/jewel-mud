module Enumerable
  def except(item)
    reject {|x| x == item }
  end
end