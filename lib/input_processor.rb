class InputProcessor
  def initialize(commands, event_manager)
    @commands, @event_manager = commands, event_manager
  end

  def process_character_commands(character)
   loop do
     begin
      cmd = parse_input_from_session(character.session)
      cmd.execute_as(character) if cmd
     rescue NoCommandFound
      character.session.write("I beg you pardon? What are you trying to say?")  
     end
    end
  end

  def parse_input_from_session(session)
    input = session.read.strip
    @commands.each do |command_class|
      command = command_class.parse(input)
      return command if command 
    end
    raise NoCommandFound.new
  end
end
