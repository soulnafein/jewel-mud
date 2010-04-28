require "spec/spec_helper"

describe Location do
  before :each do
    @telnet_session = mock.as_null_object
  end

  context "When someone leaves the location" do
    before :each do
      @telnet_session = mock.as_null_object
      @character = Character.new("David", @telnet_session)
      @location = Location.new(1, "title", "description")
      @destination = Location.new(2, "destination", "destination")
      @location.add_exit(Exit.new("east", @destination))
    end

    it "should remove character from current location" do
      @location.add_character(@character)

      @location.character_leaving(@character, "east")

      @location.characters.should be_empty
    end

    it "should send an enter event to the destination" do
      @location.add_character(@character)
      expect_event(@character, @destination, :enter, :origin => @location)
      
      @location.character_leaving(@character, "east")
    end

    it "should notify the actor if the destination does not exist" do
      @location.add_character(@character)

      invalid_call = lambda { @location.character_leaving(@character, "not_existing") }

      invalid_call.should raise_error ExitNotAvailable
    end

    it "should notify other characters in the location" do
      other_character = Character.new("other")
      @location.add_character(@character)
      @location.add_character(other_character)

      expect_event(@character, @destination, :enter, :origin => @location)
      expect_event(@location, other_character, :show, :message => "David leaves east.")
      
      @location.character_leaving(@character, "east")
    end
  end
end
