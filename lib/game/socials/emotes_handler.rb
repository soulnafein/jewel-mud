class EmotesHandler
  def handle_emote(e)
    actor = e.from
    location = e.to
    emote = e.args[:message]

    notification = "#{actor.name} #{emote}"
    location.notify_all_characters_except(actor, notification)
  end
end