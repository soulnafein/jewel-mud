class ShutdownCommand
  attr_reader :args
  
  def initialize(*args)
    @args = args
  end

  def self.parse(input)
    return ShutdownCommand.new if input =~ /^shutdown$/i
  end

  def execute_as(player)
    puts "shutting down"
    Game.instance.shutdown
  end
end