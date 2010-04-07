class InputProcessor
  def initialize(commands, event_manager)
    @commands, @event_manager = commands, event_manager
  end

  def process_player_commands(player)
   loop do
      cmd = parse_input_from_session(player.session)
      cmd.execute_as(player) if cmd
    end
  end

  def parse_input_from_session(session)
    input = session.readline.chomp.strip
    @commands.each do |command_class|
      command = command_class.parse(input)
      return command if command 
    end
    raise NoCommandFound
  end
end