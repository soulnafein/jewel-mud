class Game < GServer
  attr_reader :world

  def initialize()
    super(1234)
    @sessions = []
    @characters_logged_in = []
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
  end

  def start_game
    self.start
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
        @sessions.each { |s| s.quit }
        self.shutdown
        self.stop
        puts "Shutdown complete"
      end
    end
  end

  def enter_game(session)
    @sessions << session
    authentication_process = AuthenticationProcess.new(session, @world)
    character = authentication_process.execute
    @characters_logged_in << character

    ############# TODO: NOT THREAD SAFE ###########################
    first_location = @world.locations.first
    character.move_to(first_location)
    first_location.let_in(character, nil)
    character.go("up")
    ##############################################################
    @input_processor.process_character_commands(character)
  end

  def disconnecting(port)
    session = @sessions.find {|s| s.port == port}
    @sessions.delete(session)
    character = @characters_logged_in.find {|c| c.session.equal?(session) }
    character.location.remove_character(character)
    @characters_logged_in.delete(character)
  end
end
