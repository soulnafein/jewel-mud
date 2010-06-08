class ShutdownCommand
  attr_reader :args
  
  def initialize(character, *args)
    @character = character
    @game = args[1]
  end

  def execute
    @game.shutdown_game
  end
end