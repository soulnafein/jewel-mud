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
      @character.location.should_receive(:send_to_all_except).
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

  context "When saying something" do
    it "should add a talk event for the room" do
      @location.should_receive(:send_to_all_except).
              with(@character, "[color=cyan]David says '[/color]Hello World![color=cyan]'[/color]" )

      @character.say("Hello World!")
    end

    it "should notify player of what he said" do
      @character.should_receive(:send_to_player).
              with("[color=cyan]You says '[/color]Hello World![color=cyan]'[/color]")
      @character.say("Hello World!")
    end
  end

  context "When getting an item" do
    it "should add the item to the character inventory" do
      a_pair_of_shoes = Item.new("shoes", "A pair of shoes")
      @location.should_receive(:pick_item).with("shoes").
              and_return(a_pair_of_shoes)

      @character.get("shoes")

      @character.inventory.should include a_pair_of_shoes
    end
  end

  context "When dropping an item" do
    it "should add the item to the location" do
      pencil = Item.new("pencil", "A pencil")
      @character.inventory.push(pencil)
      @location.should_receive(:add_item).with(pencil).
              and_return(pencil)

      @character.drop("pencil")

      @character.inventory.should_not include pencil
    end
  end

  context "When printing inventory" do
    it "should show all the items in the inventory" do
      pencil = Item.new("pencil", "A pencil")
      knife = Item.new("knife", "A skinning knife")
      @character.inventory.push(pencil)
      @character.inventory.push(knife)

      @session.should_receive(:write).
              with("[color=yellow]In your hands:[/color]\n"+
                   "A pencil\n" +
                   "A skinning knife\n")

      @character.print_inventory
    end
  end
end
