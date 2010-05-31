require "spec/spec_helper"

describe Character do
  before :each do
    @session = mock.as_null_object
    @location = mock.as_null_object
    @character = Character.new("David", @session, "A description")
    @character.move_to(@location)
  end
  
  context "When getting an item" do
    before :each do
      @a_pair_of_shoes = Item.new("shoes", "A pair of shoes")
    end

    it "should add the item to the character inventory" do
      @location.should_receive(:pick_item).with("shoes").
              and_return(@a_pair_of_shoes)

      @character.get("shoes")

      @character.inventory.should include @a_pair_of_shoes
    end

    it "should notify the player" do
      @location.should_receive(:pick_item).with("shoes").
              and_return(@a_pair_of_shoes)
      @session.should_receive(:write).with("You get a pair of shoes")

      @character.get("shoes")
    end

    it "should notify other characters" do
      @location.should_receive(:pick_item).with("shoes").
              and_return(@a_pair_of_shoes)
      @location.should_receive(:send_to_all_except).
              with(@character, "#{@character.name} gets a pair of shoes from the floor")

      @character.get("shoes")
    end

    it "should let the player know when the item required is not present" do
      @location.should_receive(:pick_item).with("something").
              and_raise ItemNotAvailable
      @session.should_receive(:write).with("There is no 'something' here")
      @character.get("something")
    end
  end

  context "When dropping an item" do
    it "should add the item to the location" do
      pencil = Item.new("pencil", "A pencil")
      @character.inventory.add_item(pencil)
      @location.should_receive(:add_item).with(pencil).
              and_return(pencil)

      @character.drop("pencil")

      @character.inventory.should_not include pencil
    end

    it "should notify the player" do
      pencil = Item.new("pencil", "A pencil")
      @character.inventory.add_item(pencil)
      @location.should_receive(:add_item).with(pencil)
      @session.should_receive(:write).with("You put a pencil on the floor")

      @character.drop("pencil")
    end

    it "should notify other characters" do
      pencil = Item.new("pencil", "A pencil")
      @character.inventory.add_item(pencil)
      @location.should_receive(:add_item).with(pencil)
      @location.should_receive(:send_to_all_except).
              with(@character, "#{@character.name} puts a pencil on the floor")

      @character.drop("pencil")
    end

    it "should let the player know when item not present in inventory" do
      @session.should_receive(:write).with("You don't have it")

      @character.drop("shoes")
    end
  end

  context "When printing inventory" do
    it "should show all the items in the inventory" do
      pencil = Item.new("pencil", "a pencil")
      knife = Item.new("knife", "A skinning knife")
      @character.inventory.add_item(pencil)
      @character.inventory.add_item(knife)

      @session.should_receive(:write).
              with("[color=yellow]In your hands:[/color]\n"+
                   "A pencil\n" +
                   "A skinning knife\n")

      @character.print_inventory
    end

    it "should notify if there is nothing in the inventory" do
      @session.should_receive(:write).
              with("[color=yellow]In your hands:[/color]\n"+
                   "Nothing...\n")
      @character.print_inventory
    end
  end
end