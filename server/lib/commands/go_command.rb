class GoCommand
  attr_reader :exit
  
  def initialize(character, *args)
    @character = character
    @exit = args.first #TODO: Rename to direction
  end

  def execute
    @character.go(@exit)
  end
end