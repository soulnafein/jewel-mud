require "spec/spec_helper"

describe Character do
  before :each do
    @session = mock.as_null_object
    @location = mock.as_null_object
    @character = Character.new("David", @session, "A description")
    @character.move_to(@location)
    @hat = Item.new("hat", "a woolly hat", :wearable_on => :head)
    @helmet = Item.new("helmet", "an iron helmet", :wearable_on => :head)
  end
  
  context "When wearing an item on a naked body part" do
    before :each do
      @character.inventory.add_item(@hat)
    end

    it "should cover the body part with the item" do
      @character.wear("Hat")
      @character.head.garment.should == @hat
    end

    it "should let the player know" do
      @session.should_receive(:write).with("You wear a woolly hat")
      @character.wear("Hat")
    end

    it "should let the other characters in the location know" do
      @location.should_receive(:send_to_all_except).
              with(@character, "David wears a woolly hat")
      @character.wear("Hat")
    end
  end

  context "When trying to wear an item on a occupied body part" do
    it "should notify the player" do
      @character.inventory.add_item(@hat)
      @character.wear("hat")
      @character.inventory.add_item(@helmet)

      @session.should_receive(:write).
              with("You have something on the head already")
      @character.wear("helmet")
    end
  end

  context "When trying to wear an item not in inventory" do
    it "should notify the player" do
      @session.should_receive(:write).with("You don't have it")
      @character.wear("Something not owned")
    end
  end
end
