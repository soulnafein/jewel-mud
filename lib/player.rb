class Character
  attr_reader :name, :current_location, :session

  def initialize(name, session=nil)
    @name, @session = name, session
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
end