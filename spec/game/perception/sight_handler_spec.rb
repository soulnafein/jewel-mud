require "spec/spec_helper"

describe SightHandler do
  before :each do
    @sight_handler = SightHandler.new
  end

  context "When someone look a location" do
    it "should send a show event to the observer" do
      location = Location.new(1, "A title", "A description")
      location.add_exit(Exit.new("north", nil))
      location.add_exit(Exit.new("south", nil))
      location.add_exit(Exit.new("east", nil))
      location.add_character(Build.a_character)

      observer = Character.new("Observer", @telnet_session)

      look_event = Event.new(observer, location, :look)

      expected_description = "You see:\n" +
              "[color=red]A title[/color]\n" +
              "A description\n"+
              "People:\n" +
              "David\n" +
              "[color=green]You see exits leading north, south and east.[/color]\n"

      @telnet_session.should_receive(:write).with(expected_description)

      @sight_handler.handle_look(look_event)
    end
  end

  context "When someone look towards a direction" do
    context "When the exit exist" do
      it "should send the exit description to the observer" do
        location = Location.new(1, "A title", "A description")
        location.add_exit(Exit.new("west", nil, "Exit description"))
        observer = Character.new("Observer", @telnet_session)
        look_event = Event.new(observer, location, :look, :target => "west")

        @telnet_session.should_receive(:write).with("Exit description")

        location.on_look(look_event)
      end
    end

    context "When the exit does not exist" do
      it "should let the observer know" do
        location = Location.new(1, "A title", "A description")
        observer = Character.new("Observer", @telnet_session)
        look_event = Event.new(observer, location, :look, :target => "west")

        @telnet_session.should_receive(:write).with("There isn't anything called 'west' here.")

        location.on_look(look_event)



      end
    end
  end
end