class EventManager
  def initialize(world)
    @world = world
    @events = []
    @mutex = Mutex.new
  end

  def add_event(from,to,kind,args=[])
    @mutex.synchronize do
      @events.push(Event.new(from,to,kind,args))
    end
  end

  def get_event
    @mutex.synchronize do
      @events.shift
    end
  end

  def process_events
    e = get_event

    return if e.nil?
    
    destination = e.to
    method = "on_" + e.kind.to_s
    destination.send(method, e)
  end
end