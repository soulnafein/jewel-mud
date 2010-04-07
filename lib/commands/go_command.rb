class GoCommand
  attr_reader :args
  
  def initialize(*args)
    @args = args
    @exit = @args.first
  end

  def self.parse(input)
    if input =~ /^go ([^ ]+)$/i
      return GoCommand.new($1.downcase)
    end
  end

  def execute_as(player)
    Game.instance.add_event(player, player.current_location, :leave, :exit => @exit)
  end
end