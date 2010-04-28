class EventManager
  def initialize()
    @events = []
    @mutex = Mutex.new
    @subscribers = {}
  end

  def add_event(event)
    @mutex.synchronize do
      @events.push(event)
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

    subscribers = @subscribers[e.kind]
    if subscribers
      subscribers.each do |subscriber|
        subscriber.send("handle_#{e.kind.to_s}", e)
      end
    end
  end

  def subscribe(subscriber, event_kind)
    if not @subscribers.has_key?(event_kind)
      @subscribers[event_kind] = []
    end

    @subscribers[event_kind].push(subscriber)
  end
end