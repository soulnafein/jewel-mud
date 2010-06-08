require "spec/spec_helper"

describe Location do
  before :each do
    @telnet_session = mock.as_null_object
    @character = Character.new("David", @telnet_session)
    @location = Location.new("A title", "A description")
    @destination = Location.new("destination", "destination")
    @exit = Exit.new("east", @destination)
    @location.add_exit(@exit)
  end

  context "When a character ask to leave through a valid exit" do
    it "should let the exit know" do
      @exit.should_receive(:let_go).
              with(@character)
      @location.let_go(@character, "east")
    end

    it "should remove character from current location" do
      @location.add_character(@character)

      @location.let_go(@character, "east")

      @location.characters.should be_empty
    end

    it "should notify other characters in the location" do
      other_character = Character.new("other", mock.as_null_object)
      @location.add_character(@character)
      @location.add_character(other_character)

      other_character.should_receive(:send_to_player).with("David leaves east")

      @location.let_go(@character, "east")
    end
  end

  context "When a character ask to leave through an invalid exit" do
    it "should raise an error" do
      call_with_error = lambda {@location.let_go(@character, "i don't exist")}
      call_with_error.should raise_error ExitNotAvailable
    end
  end

  context "When a character ask to be let in the location" do
    it "should add the character to the location" do
      origin = Location.new("origin", "origin description")
      @location.characters.should_not include @character

      @location.let_in(@character, origin)

      @location.characters.should include @character
    end

    it "should notify other characters" do
      origin = Location.new("origin", "origin description")
      @location.add_exit(Exit.new("south", origin))
      other_character = mock(:other_character).as_null_object
      @location.add_character(other_character)
      other_character.should_receive(:send_to_player).with("David arrives walking from south")

      @location.let_in(@character, origin)
    end

    it "should notify other characters when origin is unknown" do
      origin = Location.new("origin", "origin description")
      other_character = mock(:other_character).as_null_object
      @location.add_character(other_character)
      other_character.should_receive(:send_to_player).with("David appears out of thin air")

      @location.let_in(@character, origin)
    end
  end

  context "When getting an item" do
    it "should return an item when it is present" do
      a_pair_of_shoes = Item.new("shoes", "A pair of shoes")
      @location.add_item(a_pair_of_shoes)

      @location.pick_item("shOes").should == a_pair_of_shoes
    end

    it "should remove the item from the location" do
      a_pair_of_shoes = Item.new("shoes", "A pair of shoes")
      @location.add_item(a_pair_of_shoes)

      @location.pick_item("shOes")
      lambda { @location.pick_item("shOes") }.
              should raise_error ItemNotAvailable
    end

  end
  
  it "should provide a summary description of the location" do
    @location.add_exit(Exit.new("north", nil))
    @location.add_exit(Exit.new("south", nil))
    @location.add_character(@character)
    @location.add_item(Item.new("table", "a wooden table"))

    observer = Character.new("Observer", nil)

    expected_description = "You see:\n" +
            "[color=red]A title[/color]\n" +
            "A description"+
            "[color=green]You see exits leading east, north and south.[/color]\n" +
            "[color=yellow]David is here\n[/color]" +
            "[color=yellow]A wooden table is here[/color]\n"

    @location.description_for(observer).should == expected_description
  end

  context "when asking for an entity by name" do
    it "should return items" do
      expected_item = Item.new("table", "a wooden table")
      @location.add_item(expected_item)
      @location.get_entity_by_name("table").should == expected_item
    end

    it "should return exits" do
      expected_exit = Exit.new("south", "you see this")
      @location.add_exit(expected_exit)
      @location.get_entity_by_name("south").should == expected_exit
    end

    it "should return characters" do
      expected_character = Character.new("David", "description")
      @location.add_item(expected_character)
      @location.get_entity_by_name("David").should == expected_character
    end

    it "should raise error when entity not found" do
      lambda {@location.get_entity_by_name("xxx")}.should raise_error EntityNotAvailable
    end
  end
end
