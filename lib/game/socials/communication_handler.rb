class CommunicationHandler
  def initialize(event_handler=nil)
    @event_handler = event_handler
    return if not @event_handler
    @event_handler.subscribe(self, :talk)
  end
  
  def handle_talk(e)
    speaker = e.from
    location = e.to
    message = e.args[:message]

    notification = "#{speaker.name} said: #{message}"
    location.notify_all_characters_except(speaker, notification)
  end
end