class Game
  include Singleton

  attr_reader :world

  def initialize
    @world = World.new
    @command_manager = CommandManager.new
    @command_factory = CommandFactory.new
    @command_factory.aliases = {
      "s" => "go south", "n" => "go north", "w" => "go west", "e" => "go east",
      "u" => "go up", "d" => "go down", "l" => "look", "i" => "inventory", "inv" => "inventory",
      "equip" => "equipment", "eq" => "equipment"
    }
    @input_processor = InputProcessor.new(@command_factory, @command_manager)
    @shutdown_requested = false
  end

  def run
    Thread.abort_on_exception = true
    Thread.new do
      begin
        until @shutdown_requested
          @command_manager.process_commands
        end
      rescue Exception => e
        puts e.message
        puts e.backtrace.inspect
      ensure
        exit
      end
    end
  end

  def enter_game(session)
    authentication_process = AuthenticationProcess.new(session, @world)
    character = authentication_process.execute

    ############# TODO: NOT THREAD SAFE ###########################
    first_location = @world.locations.first
    character.move_to(first_location)
    first_location.let_in(character, nil)
    character.go("up")
    ##############################################################
    @input_processor.process_character_commands(character)
  end

  def shutdown
    @shutdown_requested = true
  end
end
