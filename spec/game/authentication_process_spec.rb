require "spec/spec_helper"

describe AuthenticationProcess do
  it "should create a new character from session" do
    world = mock
    session = valid_character_creation_answers
    expected_description = "First line of description.\n" +
            "Second line of description.\n" +
            "Last line of description.\n"
    world.should_receive(:create_new_character).
            with("Zelgadis", session, "pa55w0rd", expected_description).
            and_return(Character.new("Zelgadis", session, "pa55w0rd", expected_description ))
    authentication_process = AuthenticationProcess.new(session, world)

    character = authentication_process.execute

    character.name.should == "Zelgadis"
  end

  it "should login a character given valid name and password" do
    world = mock
    session = valid_login_answers
    authentication_process = AuthenticationProcess.new(session, world)
    world.should_receive(:get_character_by_name_and_password).
            with("Zelgadis", "pa55w0rd").
            and_return(Character.new("Zelgadis", nil, "pa55w0rd"))

    character = authentication_process.execute

    character.name.should == "Zelgadis"
    character.session.should == session
  end

  it "should allow to retry when the details are wrong" do
    world = mock
    session = invalid_login_answers
    authentication_process = AuthenticationProcess.new(session, world)
    world.should_receive(:get_character_by_name_and_password).
            with("Blahblah", "wrongpass").
            and_return(nil)
    world.should_receive(:get_character_by_name_and_password).
            with("Zelgadis", "pa55w0rd").
            and_return(Character.new("Zelgadis", nil, "password"))
    authentication_process.execute
  end

  def invalid_login_answers
    session = mock(:telnet_session).as_null_object

    expect_message(session,
                   "What would you like to do?\n" +
                           "1) Login with existing character\n" +
                           "2) Create a new character\n")
    expect_input(session, "1")
    expect_message(session, "What's your character name?")
    expect_input(session, "Blahblah")
    expect_message(session, "Password:")
    expect_input(session, "wrongpass")
    expect_message(session, "Wrong details, try again.")
    expect_message(session, "What's your character name?")
    expect_input(session, "zelgadis")
    expect_message(session, "Password:")
    expect_input(session, "pa55w0rd")
    expect_message(session, "Welcome to Britannia Zelgadis!")
    session
  end

  def valid_character_creation_answers
    session = mock(:telnet_session).as_null_object

    expect_message(session,
                   "What would you like to do?\n" +
                           "1) Login with existing character\n" +
                           "2) Create a new character\n")
    expect_input(session, "2")
    expect_message(session, "What's your character name?")
    expect_input(session, "zelgadis")
    expect_message(session, "Choose a password for Zelgadis:")
    expect_input(session, "pa55w0rd")
    expect_message(session, "Choose a description that other players will " +
                            "see when they look to your character.\r\n" +
                            "Enter a line with END written in it when you finished.")
    expect_input(session, "First line of description.")
    expect_message(session, "First line of description.")
    expect_input(session, "Second line of description.")
    expect_message(session, "Second line of description.")
    expect_input(session, "Last line of description.")
    expect_message(session, "Last line of description.")
    expect_input(session, "END")
    expect_message(session, "Welcome to Britannia Zelgadis!")
    session
  end

  def valid_login_answers
    session = mock(:telnet_session).as_null_object

    expect_message(session,
                   "What would you like to do?\n" +
                           "1) Login with existing character\n" +
                           "2) Create a new character\n")
    expect_input(session, "1")
    expect_message(session, "What's your character name?")
    expect_input(session, "zelgadis")
    expect_message(session, "Password:")
    expect_input(session, "pa55w0rd")
    expect_message(session, "Welcome to Britannia Zelgadis!")
    session
  end

  def expect_message(session, message)
    session.should_receive(:write).once.ordered.with(message)
  end

  def expect_input(session, input)
    session.should_receive(:read).once.ordered.and_return(input)
  end

end
