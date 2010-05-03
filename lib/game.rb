class Game
  include Singleton

  attr_reader :world

  def initialize
    @world = World.new
    @event_manager = EventManager.new
    @command_manager = CommandManager.new
    register_event_handlers(@event_manager)
    commands = [SayCommand, ShutdownCommand, LookCommand, GoCommand, EmoteCommand]
    @input_processor = InputProcessor.new(commands, @event_manager, @command_manager)
    @shutdown_requested = false
  end

  def run
    Thread.abort_on_exception = true
    Thread.new do
      begin
        until @shutdown_requested
          @command_manager.process_commands
          @event_manager.process_events
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
    add_event(character, @world.locations.first, :enter, :origin => :nowhere)
    @input_processor.process_character_commands(character)
  end

  def add_event(from, to, kind, args={})
    @event_manager.add_event(Event.new(from,to,kind,args))
  end

  def shutdown
    @shutdown_requested = true
  end

  def register_event_handlers(event_manager)
    @movement_handler = MovementHandler.new(event_manager)
    @sight_handler = SightHandler.new(event_manager)
    @emote_handler = EmotesHandler.new(event_manager)
    @communication = CommunicationHandler.new(event_manager)
  end
end

def add_event(from, to, kind, args={})
  Game.instance.add_event(from, to, kind, args)
end
