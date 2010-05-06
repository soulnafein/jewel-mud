require "spec/spec_helper"

describe Character do
  before :each do
    @session = mock.as_null_object
    @location = mock.as_null_object
    @character = Character.new("David", @session, "A description")
    @character.move_to(@location)
  end

  it "should change current location" do
    location = Location.new(1, "Example", "Description")

    @character.move_to(location)

    @character.location.should == location
  end

  context "When emoting" do
    it "should send notification to attached session" do
      @session.should_receive(:write).with("You emote: David licks his finger")

      @character.emote("licks his finger")
    end

    it "should send message to his location" do
      @character.location.should_receive(:notify_all_characters_except).
              with(@character, "David licks his finger")
      @character.emote("licks his finger")
    end
  end

  context "When going through a valid exit" do
    it "should ask location to go through an exit" do
      @location.should_receive(:let_go).
              with(@character, "east")
      @character.go("east")
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

  context "When looking at a location" do
    it "should send location description to the session" do
      description = "A description"
      @location.should_receive(:description_for).with(@character).
              and_return(description)
      @session.should_receive(:write).with(description)
      @character.move_to(@location)

      @character.look
    end
  end

  context "When looking at an entity" do
    it "should send location description to the session" do
      @location.should_receive(:get_entity_description).
              with("east").and_return("You see a pub")
      @session.should_receive(:write).with("You see a pub")

      @character.look("east")
    end
  end
end
