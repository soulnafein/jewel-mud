require "spec/spec_helper"

describe MovementHandler do
  context "When a character want to leave a location" do
    before :each do
      @telnet_session = mock.as_null_object
      @character = Character.new("David", @telnet_session)
      @location = Location.new(1, "title", "description")
      @destination = Location.new(2, "destination", "destination")
      @location.add_exit(Exit.new("east", @destination))
      @movement_handler = MovementHandler.new
    end

    it "should let the location know" do
      enter_event = Event.new(@character, @location, :leave, :exit => "east")

      @location.should_receive(:character_leaving).
              with(@character, "east")

      @movement_handler.handle_leave(enter_event)
    end

    it "should notify the character if the exit required does not exist" do
      enter_event_with_invalid_exit =
              Event.new(@character, @location, :leave, :exit => "I don't exist")

      @location.should_receive(:character_leaving).
              with(@character, "I don't exist").
              and_raise(ExitNotAvailable.new)

      @character.should_receive(:notification).
              with("You can't go in that direction.")

      @movement_handler.handle_leave(enter_event_with_invalid_exit)
    end
  end

  context "When a character want to enter a location" do
    before :each do
      @character = Character.new("David")
      @origin = Location.new(2, "origin", "description")
      @location = Location.new(1, "title", "description")
      @origin.add_exit(Exit.new("east", @location))
      @location.add_exit(Exit.new("west", @origin))
      @movement_handler = MovementHandler.new
    end

    it "should add the character at the list of character" do
      enter_event = Event.new(@character, @location, :enter, :origin => @origin)
      @location.should_receive(:add_character).with(@character)
      @movement_handler.handle_enter(enter_event)
    end

    it "should notify other characters in the location" do
      enter_event = Event.new(@character, @location, :enter, :origin => @origin)

      @location.should_receive(:notify_all_characters_except).
              with(@character, "David arrives walking from west")
      @movement_handler.handle_enter(enter_event)
    end

    it "should change notification when appearing magically" do
      enter_event = Event.new(@character, @location, :enter, :origin => :nowhere)

      @location.should_receive(:notify_all_characters_except).
              with(@character, "David appears out of thin air")
      @movement_handler.handle_enter(enter_event)
    end

    it "should show description of the room to the character" do
      enter_event = Event.new(@character, @location, :enter, :origin => @origin)

      expect_event(@character, @location, :look)
      @movement_handler.handle_enter(enter_event)
    end
  end
end