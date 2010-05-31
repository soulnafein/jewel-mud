class Game < GServer
  attr_reader :world

  def initialize()
    super(1234)
    @world = World.new
    @command_manager = CommandManager.new
    @command_factory = CommandFactory.new(self)
    @command_factory.aliases = {
      "s" => "go south", "n" => "go north", "w" => "go west", "e" => "go east",
      "u" => "go up", "d" => "go down", "l" => "look", "i" => "inventory", "inv" => "inventory",
      "equip" => "equipment", "eq" => "equipment"
    }
    @input_processor = InputProcessor.new(@command_factory, @command_manager, self)
    @shutdown_requested = false
    self.audit = true
    self.debug = true
    self.start
  end

  def start_game
    self.join
  end

  def starting
    run
  end

  def serve(socket)
    telnet_session = TelnetSession.new(socket)
    enter_game(telnet_session)
  end

  def shutdown_game
    @shutdown_requested = true
  end

  private
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
        puts "Shutting down..."
        self.shutdown
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
end
