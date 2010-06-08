class GetCommand
  attr_reader :item

  def initialize(character, *args)
    @character = character
    @item = args.first
  end

  def execute
    @character.get(@item)
  end
end