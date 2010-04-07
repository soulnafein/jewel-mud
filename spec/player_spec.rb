require "spec/spec_helper"

describe Player do
  it "should change current location" do
    location = Location.new(1, "Example", "Description")
    player = Build.a_player

    player.move_to(location)

    player.current_location.should == location
  end

  it "should send a notification to the current session" do
    player = Build.a_player
    event = Event.new(player, player, :show, :message => "Oh Yeah!")

    player.session.should_receive(:puts).with("Oh Yeah!")

    player.on_show(event)
  end
end
