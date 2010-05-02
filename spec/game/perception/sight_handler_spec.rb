require "spec/spec_helper"

describe SightHandler do
  before :each do
    @sight_handler = SightHandler.new
    @location = Location.new(1, "A title", "A description")
    @telnet_session = mock.as_null_object
    @observer = Character.new("Observer", @telnet_session)
  end

  context "When someone look a location" do
    it "should send a show event to the observer" do
      @location.add_exit(Exit.new("north", nil))
      @location.add_exit(Exit.new("south", nil))
      @location.add_exit(Exit.new("east", nil))
      @location.add_character(Build.a_character)

      look_event = Event.new(@observer, @location, :look)

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
        @location.add_exit(Exit.new("West", nil, "Exit description"))

        look_event = Event.new(@observer, @location, :look, :target => "west")

        @telnet_session.should_receive(:write).with("Exit description")

        @sight_handler.handle_look(look_event)
      end
    end

    context "When the exit does not exist" do
      it "should let the observer know" do
        look_event = Event.new(@observer, @location, :look, :target => "west")

        @telnet_session.should_receive(:write).with("There isn't anything called 'west' here.")

        @sight_handler.handle_look(look_event)
      end
    end
  end

  context "When someone looks at another character" do
    it "should send the character description to the observer" do
      @location.add_character(Character.new("Pino",nil, nil, "A description" ))
      look_event = Event.new(@observer, @location, :look, :target => "pino")

      @telnet_session.should_receive(:write).with("A description")

      @sight_handler.handle_look(look_event)
    end
  end
end