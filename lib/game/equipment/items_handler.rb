class ItemsHandler
  def initialize(event_handler=nil)
    @event_handler = event_handler
    return if not @event_handler
    @event_handler.subscribe(self, :get)
  end
  
  def handle_get(e)
    character = e.from
    location = e.to
    item_name = e.args[:item]

  end
end