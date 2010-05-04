class InputProcessor
  def initialize(commands, command_manager)
    @commands, @command_manager = commands, command_manager
  end

  def process_character_commands(character)
   loop do
     begin
      cmd = parse_input_from_session(character)
      @command_manager.add_command(cmd) if cmd
     rescue NoCommandFound
      character.session.write("I beg you pardon? What are you trying to say?")  
     end
    end
  end

  def parse_input_from_session(character)
    input = character.session.read
    @commands.each do |command_class|
      command = command_class.parse(input, character)

      return command if command 
    end
    raise NoCommandFound.new
  end
end
