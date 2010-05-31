class InputProcessor
  def initialize(command_factory, command_manager, game)
    @command_factory, @command_manager, @game = command_factory, command_manager, game
    @shutdown_requested = false
  end

  def process_character_commands(character)
    session = character.session    
    while session.open?
      input = session.read
      cmd = @command_factory.parse(input, character)
      @command_manager.add_command(cmd)
    end
  end
end
