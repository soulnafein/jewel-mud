class InventoryCommand
  def initialize(character)
    @character = character
  end

  def execute
    @character.print_inventory
  end
end