class DropCommand
  attr_reader :item

  def initialize(character, *args)
    @character = character
    @item = args.first
  end

  def execute
    @character.drop(@item)
  end
end