class Game
  include Singleton

  attr_reader :world

  def initialize
    @world = World.new
    @event_manager = EventManager.new(@world)
    commands = [SayCommand, ShutdownCommand, LookCommand, GoCommand]
    @input_processor = InputProcessor.new(commands, @event_manager)
    @shutdown_requested = false
  end

  def run
    Thread.abort_on_exception = true
    Thread.new do
      loop do
        process_events
        exit if @shutdown_requested
      end
    end
  end

  def new_session(session)
    session.puts "Qual'e' il tuo nome?"
    name = session.readline.chomp
    session.puts "Benvenuto #{name}"
    player = Player.new(name, session)
    @world.add_player(player)
    @input_processor.process_player_commands(player)
  end

  def add_event(from, to, kind, msg=nil)
    @event_manager.add_event(from, to, kind, msg)
  end

  def shutdown
    @shutdown_requested = true
  end

  private
  def process_events
    @event_manager.process_events
  end
end

def add_event(from, to, kind, args=nil)
  Game.instance.add_event(from, to, kind, args)
end
