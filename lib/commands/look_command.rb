class LookCommand
  attr_reader :args
  
  def initialize(*args)
    @args = args
  end

  def self.parse(input)
    return LookCommand.new if input =~ /^look$/i
  end

  def execute_as(player)
    Game.instance.add_event(player,player.current_location,:look)
  end
end