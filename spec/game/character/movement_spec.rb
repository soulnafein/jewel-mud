require 'spec/spec_helper'

describe Character do
  before :each do
    @session = mock.as_null_object
    @location = mock.as_null_object
    @character = Character.new("David", @session, "A description")
    @character.move_to(@location)
  end
  
  context "When going through a valid exit" do
    it "should ask location to go through an exit" do
      @location.should_receive(:let_go).
              with(@character, "east")
      @character.go("east")
    end
    
    it "should change current location" do
      location = Location.new("Example", "Description")

      @character.move_to(location)

      @character.location.should == location
    end

  end

  context "When going through an invalid exit" do
    it "should notify player" do
      @location.should_receive(:let_go).
              with(@character, "west").and_raise(ExitNotAvailable)
      @session.should_receive(:write).with("You can't go in that direction.")
      @character.go("west")
    end
  end
end
