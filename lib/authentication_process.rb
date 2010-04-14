class AuthenticationProcess
  def initialize(session)
    @session, @world = session
  end

  def execute
    @session.write("What would you like to do?\n\r" +
                   "1) Login with existing character\n\r" +
                   "2) Create a new character\n\r")
    choice = @session.read
    @session.write("What's your character name?")
    name = @session.read.capitalize
    @session.write("Welcome to Britannia #{name}!")
    Character.new(name, @session)
  end
end
