require "spec/spec_helper"

describe AuthenticationProcess do
  it "should create a new character from session" do
    session = mock_answers
    authentication_process = AuthenticationProcess.new(session)

    character = authentication_process.execute

    character.name.should == "Zelgadis"
  end

  def mock_answers
    session = mock("tcp_io").as_null_object

    session.should_receive(:puts).once.ordered.with("What's your character name?")
    session.should_receive(:readline).once.ordered.and_return("zelgadis\n")
    session.should_receive(:puts).once.ordered.with("Welcome to Britannia Zelgadis!")
    session
  end
end
