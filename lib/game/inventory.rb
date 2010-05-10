class Inventory
  def initialize
    @items = []
  end

  def add(item)
    @items.push item
  end

  def pick(item_name)
    item = @items.find {|i| i.name == item_name}
    raise ItemNotAvailable if not item
    @items.delete(item)
  end

  def include?(item)
    @items.include?(item)
  end

  def display
    output = "[color=yellow]In your hands:[/color]\n"
    @items.each { |i| output += "#{i.description}\n" }
    output
  end
end