require 'lib/game/items_container'
class Inventory
  include ItemsContainer

  def initialize
    initialize_items_container
  end

  def display
    output = "[color=yellow]In your hands:[/color]\n"
    @items.each { |i| output += "#{i.description.capitalize}\n" }
    output += "Nothing...\n" if @items.empty?
    output
  end
end