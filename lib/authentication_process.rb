class AuthenticationProcess
  def initialize(session)
    @session, @world = session
  end

  def execute
    @session.puts("What's your character name?")
    name = @session.readline.chomp.capitalize
    @session.puts("Welcome to Britannia #{name}!")
    Player.new(name, @session)
  end
end