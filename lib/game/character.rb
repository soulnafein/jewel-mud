class Character
  attr_reader :name, :password, :location, :session, :description

  def initialize(name, session=nil, password=nil, description=nil)
    @name, @session, @password, @description =
    name, session, password, description
  end

  def notification(msg)
    @session.write msg
  end

  def move_to(location)
    @location = location
  end

  def bind_session(session)
    @session = session
  end

  def to_yaml_properties
    ['@name', '@password', '@description']
  end

  def look(target="")
    if not target.empty?
      description = @location.get_entity_description(target)
    else
      description = @location.description_for(self)
    end

    notification(description)
  end

  def emote(emote_description)
    emote_message = "#{@name} #{emote_description}"
    @session.write "You emote: #{emote_message}"
    @location.notify_all_characters_except(self, emote_message)
  end

  def go(direction)
    begin
      @location.let_go(self, direction)
    rescue ExitNotAvailable
      @session.write "You can't go in that direction."
    end
  end
end