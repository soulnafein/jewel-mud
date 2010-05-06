require "spec/spec_helper"

describe Location do
  before :each do
    @telnet_session = mock.as_null_object
    @character = Character.new("David", @telnet_session)
    @location = Location.new(1, "A title", "A description")
    @destination = Location.new(2, "destination", "destination")
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

      other_character.should_receive(:send_to_player, "David leaves east.")

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
      origin = Location.new(5, "origin", "origin description")
      @location.characters.should_not include @character

      @location.let_in(@character, origin)

      @location.characters.should include @character
    end

    it "should notify other characters" do
      origin = Location.new(5, "origin", "origin description")
      @location.add_exit(Exit.new("south", origin))
      other_character = mock(:other_character).as_null_object
      @location.add_character(other_character)
      other_character.should_receive(:send_to_player).with("David arrives walking from south")

      @location.let_in(@character, origin)
    end

    it "should notify other characters when origin is unknown" do
      origin = Location.new(5, "origin", "origin description")
      other_character = mock(:other_character).as_null_object
      @location.add_character(other_character)
      other_character.should_receive(:send_to_player).with("David appears out of thin air")

      @location.let_in(@character, origin)
    end
  end

  context "When asking for the description of an entity" do
    it "should get the description when it exists" do
      @location.add_character(@character)

      description = @location.get_entity_description(@character.name)

      description.should == @character.description
    end
  end

  it "should provide a summary description of the location" do
    @location.add_exit(Exit.new("north", nil))
    @location.add_exit(Exit.new("south", nil))
    @location.add_character(@character)

    observer = Character.new("Observer", nil)

    expected_description = "You see:\n" +
            "[color=red]A title[/color]\n" +
            "A description\n"+
            "People:\n" +
            "David\n" +
            "[color=green]You see exits leading east, north and south.[/color]\n"

    @location.description_for(observer).should == expected_description
  end
end
