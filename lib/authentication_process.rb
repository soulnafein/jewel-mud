class AuthenticationProcess
  def initialize(session)
    @session, @world = session
  end

  def execute
    @session.write("What's your character name?")
    name = @session.read.capitalize
    @session.write("Welcome to Britannia #{name}!")
    Character.new(name, @session)
  end
end