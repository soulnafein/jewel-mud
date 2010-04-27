class Character
  attr_reader :name, :password, :current_location, :session

  def initialize(name, session=nil, password=nil)
    @name, @session, @password = name, session, password
  end

  def notification(msg)
    @session.write msg
  end

  def move_to(location)
    @current_location = location
  end

  def on_show(e)
    notification(e.args[:message])
  end

  def bind_session(session)
    @session = session
  end

  def to_yaml_properties
    ['@name', '@password']
  end
end