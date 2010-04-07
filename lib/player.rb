class Player
  attr_reader :name, :current_location, :session

  def initialize(name, session)
    @name, @session = name, session
  end

  def message(msg)
    @session.puts msg
  end

  def notification(msg)
    @session.puts msg
  end

  def on_show(e)
    notification(e.args[:message])
  end

  def move_to(location)
    @current_location = location
  end
end