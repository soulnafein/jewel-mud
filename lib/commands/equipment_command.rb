class EquipmentCommand
  def initialize(character, *args)
    @character = character
  end

  def execute
    @character.print_equipment
  end
end