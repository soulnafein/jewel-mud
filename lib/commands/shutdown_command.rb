class ShutdownCommand
  attr_reader :args
  
  def initialize(character, event_manager, *args)
    @character, @event_manager = character, event_manager
    @args = args
  end

  def self.parse(input, character, event_manager)
    return ShutdownCommand.new(character, event_manager) if input =~ /^shutdown$/i
  end

  def execute
    Game.instance.shutdown
  end
end