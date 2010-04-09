require "spec/spec_helper"

describe Character do
  it "should change current location" do
    location = Location.new(1, "Example", "Description")
    character = Build.a_character

    character.move_to(location)

    character.current_location.should == location
  end

  it "should send a notification to the current session" do
    character = Build.a_character
    event = Event.new(character, character, :show, :message => "Oh Yeah!")

    character.session.should_receive(:puts).with("Oh Yeah!")

    character.on_show(event)
  end
end
