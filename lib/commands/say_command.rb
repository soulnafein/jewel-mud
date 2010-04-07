class SayCommand
  attr_reader :args
  
  def initialize(*args)
    @args = args
    @message = args.first
  end

  def self.parse(input)
    if input =~ /say (.*)/i
      return SayCommand.new($1)
    end
  end

  def execute_as(player)
    player.notification("You said: #{@message}")
    Game.instance.add_event(player, player.current_location, :talk, :message => @message)
  end
end