class Game
  include Singleton

  attr_reader :world

  def initialize
    @world = World.new
    @event_manager = EventManager.new()
    commands = [SayCommand, ShutdownCommand, LookCommand, GoCommand]
    @input_processor = InputProcessor.new(commands, @event_manager)
    @shutdown_requested = false
  end

  def run
    Thread.abort_on_exception = true
    Thread.new do
      until @shutdown_requested
        @event_manager.process_events
      end
      exit
    end
  end

  def enter_game(session)
    authentication_process = AuthenticationProcess.new(session)
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
end

def add_event(from, to, kind, args={})
  Game.instance.add_event(from, to, kind, args)
end
