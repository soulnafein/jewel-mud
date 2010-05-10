class InventoryCommand
  attr_reader :item

  def initialize(character, *args)
    @character = character
    @item = args.first
  end

  def execute
    @character.print_inventory
  end
end