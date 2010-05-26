class InventoryCommand
  def initialize(character, *args)
    @character = character
  end

  def execute
    @character.print_inventory
  end
end