module ItemsContainer
  def initialize_items_container
    @items = []  
  end

  def add_item(item)
    @items.push(item)
  end

  def pick_item(item_name)
    item = @items.find {|i| i.name.downcase == item_name.downcase}
    raise ItemNotAvailable if not item
    @items.delete(item)
  end
  
  def include?(item)
    @items.include?(item)
  end
end