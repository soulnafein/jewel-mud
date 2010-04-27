class SightHandler
  def handle_look(e)
    observer = e.from
    location = e.to
    target = e.args[:target]

    if target
      description = location.get_entity_description(target)
    else
      description = location.description_for(observer)
    end

    observer.notification(description)
  end
end