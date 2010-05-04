class ShutdownCommand
  attr_reader :args
  
  def initialize(character, *args)
    @character = character
    @args = args
  end

  def self.parse(input, character)
    return ShutdownCommand.new(character) if input =~ /^shutdown$/i
  end

  def execute
    Game.instance.shutdown
  end
end