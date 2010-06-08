class RemoveCommand
  attr_reader :item

  def initialize(character, *args)
    @character = character
    @item = args.first
  end

  def execute
    @character.take_off(@item)
  end
end