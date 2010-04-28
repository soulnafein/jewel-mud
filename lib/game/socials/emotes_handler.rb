class EmotesHandler
  def initialize(event_handler=nil)
    @event_handler = event_handler
    return if not @event_handler
    @event_handler.subscribe(self, :emote)
  end

  def handle_emote(e)
    actor = e.from
    location = e.to
    emote = e.args[:message]

    notification = "#{actor.name} #{emote}"
    location.notify_all_characters_except(actor, notification)
  end
end