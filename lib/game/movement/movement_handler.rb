class MovementHandler
  def initialize(event_handler=nil)
    @event_handler = event_handler
    return if not @event_handler 
    @event_handler.subscribe(self, :enter)
    @event_handler.subscribe(self, :leave)
  end

  def handle_enter(event)
    character = event.from
    destination = event.to
    origin = event.args[:origin]

    destination.add_character(character)

    exit = destination.exit_to(origin)
    notification = "#{character.name} appears out of thin air"
    notification = "#{character.name} arrives walking from #{exit.name}" if exit

    destination.notify_all_characters_except(character, notification)

    add_event(character, destination, :look)
  end

  def handle_leave(event)
    character = event.from
    current_location = event.to
    direction = event.args[:exit]

    begin
      current_location.character_leaving(character, direction)
    rescue ExitNotAvailable
      character.notification("You can't go in that direction.")
    end
  end
end