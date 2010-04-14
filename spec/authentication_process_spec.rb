require "spec/spec_helper"

describe AuthenticationProcess do
  it "should create a new character from session" do
    session = mock_answers
    
    authentication_process = AuthenticationProcess.new(session)

    character = authentication_process.execute

    character.name.should == "Zelgadis"
  end

  def mock_answers
    session = mock(:telnet_session).as_null_object

    expect_message(session,
                   "What would you like to do?\n\r" +
                   "1) Login with existing character\n\r" +
                   "2) Create a new character\n\r")
    expect_input(session,"2")
    expect_message(session, "What's your character name?")
    expect_input(session,"zelgadis")
    expect_message(session,"Welcome to Britannia Zelgadis!")
    session
  end

  def expect_message(session, message)
    session.should_receive(:write).once.ordered.with(message)
  end

  def expect_input(session, input)
    session.should_receive(:read).once.ordered.and_return(input)
  end

end
