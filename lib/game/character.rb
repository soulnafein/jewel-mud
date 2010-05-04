class Character
  attr_reader :name, :password, :current_location, :session, :description

  def initialize(name, session=nil, password=nil, description=nil)
    @name, @session, @password, @description =
    name, session, password, description
  end

  def notification(msg)
    @session.write msg
  end

  def move_to(location)
    @current_location = location
  end

  def bind_session(session)
    @session = session
  end

  def to_yaml_properties
    ['@name', '@password', '@description']
  end

  def look(target="")
    location = @current_location
    if not target.empty?
      description = location.get_entity_description(target)
    else
      description = location.description_for(self)
    end

    notification(description)
  end
end