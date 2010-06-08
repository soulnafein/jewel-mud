require "spec/spec_helper"

describe Character do
  before :each do
    @session = mock.as_null_object
    @location = mock.as_null_object
    @character = Character.new("David", @session, "A description")
    @character.move_to(@location)
    @hat = Item.new("hat", "a woolly hat", :wearable_on => :head)
    @helmet = Item.new("helmet", "an iron helmet", :wearable_on => :head)
    @gloves = Item.new("gloves", "a pair of leather gloves", :wearable_on => :hands)
  end

  context "When wearing an item on a naked body part" do
    before :each do
      @character.inventory.add_item(@hat)
    end

    it "should cover the body part with the item" do
      @character.wear("Hat")
      @character.body.garments.should include @hat
    end

    it "should let the player know" do
      @session.should_receive(:write).with("You wear a woolly hat on your head")
      @character.wear("Hat")
    end

    it "should let the other characters in the location know" do
      @location.should_receive(:send_to_all_except).
              with(@character, "David wears a woolly hat on the head")
      @character.wear("Hat")
    end
  end

  context "When trying to wear an item on a occupied body part" do
    it "should notify the player" do
      @character.inventory.add_item(@hat)
      @character.wear("hat")
      @character.inventory.add_item(@helmet)

      @session.should_receive(:write).
              with("You have something on your head already")
      @character.wear("helmet")
    end
  end

  context "When trying to wear an item not in inventory" do
    it "should notify the player" do
      @session.should_receive(:write).with("You don't have it")
      @character.wear("Something not owned")
    end
  end

  context "When taking off a piece of clothing" do
    before :each do
      @character.inventory.add_item(@gloves)
      @character.wear("gloves")
    end

    it "should move the item to the inventory" do
      @character.take_off("gloves")
      @character.inventory.should include @gloves
    end

    it "should remove it from the body" do
      @character.take_off("gloves")
      @character.body.garments.should_not include @gloves
    end

    it "should let the player know" do
      @session.should_receive(:write).with("You take off a pair of leather gloves")
      @character.take_off("gloves")
    end

    it "should let the other characters in the location know" do
      @location.should_receive(:send_to_all_except).
              with(@character, "David takes a pair of leather gloves off")
      @character.take_off("gloves")
    end
  end

  context "When trying to take off an item not worn" do
    it "should notify the player" do
      @session.should_receive(:write).with("You don't have it")
      @character.take_off("Something not worn")
    end
  end

  context "When visualizing equipment" do
    it "should show list of all the items worn to the player" do
      @character.inventory.add_item(@gloves)
      @character.inventory.add_item(@hat)
      @character.wear("gloves")
      @character.wear("hat")

      @session.should_receive(:write).
              with("[color=yellow]You are wearing:[/color]\n"+
              "A woolly hat on your head\n" +
              "A pair of leather gloves on your hands\n")
      @character.print_equipment
    end

    it "should notify when there are not items worn" do
      @session.should_receive(:write).
              with("[color=yellow]You are wearing:[/color]\n"+
              "Nothing...\n")
      @character.print_equipment
    end
  end

  context "When looking a character" do
    it "should describe the equipment wore" do
      @character.inventory.add_item(@gloves)
      @character.inventory.add_item(@hat)
      @character.wear("gloves")
      @character.wear("hat")

      @session.should_receive(:write).
              with("Looking at David\n"+
              "[color=cyan]He's wearing a woolly hat on his head. " +
              "He's wearing a pair of leather gloves on his hands. [/color]")
      @character.look(@character)
    end

    it "should let observer know if character is naked" do
      @session.should_receive(:write).
              with("Looking at David\n"+
              "[color=cyan]He is completely naked!\n[/color]")
      @character.look(@character)
    end
  end
end
