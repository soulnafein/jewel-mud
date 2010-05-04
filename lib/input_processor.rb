class InputProcessor
  def initialize(command_factory, command_manager)
    @command_factory, @command_manager = command_factory, command_manager
  end

  def process_character_commands(character)
    loop do
      input = character.session.read
      cmd = @command_factory.parse(input, character)
      @command_manager.add_command(cmd)
    end
  end
end
