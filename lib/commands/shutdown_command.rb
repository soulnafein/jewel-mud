class ShutdownCommand
  attr_reader :args
  
  def initialize(character, *args)
    @character = character
    @args = args
  end

  def execute
    Game.instance.shutdown
  end
end