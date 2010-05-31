class QuitCommand
  attr_reader :args
  
  def initialize(character, *args)
    @character = character
  end

  def execute
    @character.session.quit
  end
end