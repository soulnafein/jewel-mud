class InputProcessor
  def initialize(commands, event_manager)
    @commands, @event_manager = commands, event_manager
  end

  def process_player_commands(player)
   loop do
     begin
      cmd = parse_input_from_session(player.session)
      cmd.execute_as(player) if cmd
     rescue NoCommandFound
      player.session.puts("I beg you pardon? What are you trying to say?")  
     end
    end
  end

  def parse_input_from_session(session)
    input = session.readline.chomp.strip
    @commands.each do |command_class|
      command = command_class.parse(input)
      return command if command 
    end
    raise NoCommandFound.new
  end
end
