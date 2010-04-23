class AuthenticationProcess
  def initialize(session, world)
    @session, @world = session, world
    @choices =
            {
              "1" => lambda { login },
              "2" => lambda { create_new_character }
            }
  end

  def execute
    @session.write("What would you like to do?\n" +
            "1) Login with existing character\n" +
            "2) Create a new character\n")
    choice = @session.read
    @choices[choice].call
  end

  private
  def create_new_character
    @session.write("What's your character name?")
    name = @session.read.capitalize
    @session.write("Choose a password for #{name}:")
    password = @session.read
    @session.write("Welcome to Britannia #{name}!")
    @world.create_new_character(name, @session, password)
  end

  def login
    @session.write("What's your character name?")
    name = @session.read.capitalize
    @session.write("Password:")
    password = @session.read
    character = @world.get_character_by_name_and_password(name, password)
    if not character
      @session.write("Wrong details, try again.")
      return login
    end
    character.bind_session(@session)
    @session.write("Welcome to Britannia #{name}!")
    character
  end
end
