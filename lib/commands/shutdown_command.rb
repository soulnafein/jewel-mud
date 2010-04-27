class ShutdownCommand
  attr_reader :args
  
  def initialize(*args)
    @args = args
  end

  def self.parse(input)
    return ShutdownCommand.new if input =~ /^shutdown$/i
  end

  def execute_as(character, event_handler)
    Game.instance.shutdown
  end
end