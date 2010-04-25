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
    @name = ask_name
    @password = ask_new_password
    @description = ask_description
    @character = @world.create_new_character(@name, @session, @password)
    visualize_welcome_message(@character.name)
    @character
  end

  def login
    @name = ask_name
    @session.write("Password:")
    @password = @session.read
    @character = @world.get_character_by_name_and_password(@name, @password)
    if not @character
      @session.write("Wrong details, try again.")
      return login
    end
    @character.bind_session(@session)
    @session.write("Welcome to Britannia #{@name}!")
    @character
  end

  def ask_name
    @session.write("What's your character name?")
    @session.read.capitalize
  end

  def visualize_welcome_message(name)
    @session.write("Welcome to Britannia #{name}!")
  end

  def ask_new_password
    @session.write("Choose a password for #{@name}:")
    @session.read
  end

  def ask_description
    @session.write "Choose a description that other players will " +
                    "see when they look to your character.\r\n" +
                    "Enter a line with END written in it when you finished."
    description = ""
    line = ""
    while line.downcase != "end"
      line = @session.read
      if line.downcase != "end"
        description += line + "\n"
        @session.write line
      end
    end
    description
  end

end
