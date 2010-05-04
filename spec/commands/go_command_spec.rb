require "spec/spec_helper"

describe GoCommand do
  context "When parsing a valid input" do
    it "should create a new go command" do
      cmd = GoCommand.parse("go east", nil)

      cmd.class.should == GoCommand
      cmd.exit.should == "east"
    end

    it "should ignore case of command" do
      cmd = GoCommand.parse("gO eaSt", nil)

      cmd.class.should == GoCommand
      cmd.exit.should == "east"
    end

    it "should ignore 'go' appearing in other contexts" do
      cmd = GoCommand.parse("say you should GO somewhere else", nil)

      cmd.should be_nil
    end
  end

  context "Shortcuts" do
    it "should accept west as a shortcut of 'go west'" do
      cmd = GoCommand.parse("west", nil)

      cmd.class.should == GoCommand
      cmd.exit.should == "west"
    end

    it "should accept w as a shortcut of 'go west'" do
      cmd = GoCommand.parse("w", nil)

      cmd.class.should == GoCommand
      cmd.exit.should == "west"
    end

    it "should accept east as a shortcut of 'go east'" do
      cmd = GoCommand.parse("east", nil)

      cmd.class.should == GoCommand
      cmd.exit.should == "east"
    end

    it "should accept e as a shortcut of 'go east'" do
      cmd = GoCommand.parse("e", nil)

      cmd.class.should == GoCommand
      cmd.exit.should == "east"
    end

    it "should accept north as a shortcut of 'go north'" do
      cmd = GoCommand.parse("north", nil)

      cmd.class.should == GoCommand
      cmd.exit.should == "north"
    end

    it "should accept n as a shortcut of 'go north'" do
      cmd = GoCommand.parse("n", nil)

      cmd.class.should == GoCommand
      cmd.exit.should == "north"
    end

    it "should accept south as a shortcut of 'go south'" do
      cmd = GoCommand.parse("south", nil)

      cmd.class.should == GoCommand
      cmd.exit.should == "south"
    end

    it "should accept s as a shortcut of 'go south'" do
      cmd = GoCommand.parse("s", nil)

      cmd.class.should == GoCommand
      cmd.exit.should == "south"
    end

    it "should accept up as a shortcut of 'go up'" do
      cmd = GoCommand.parse("up", nil)

      cmd.class.should == GoCommand
      cmd.exit.should == "up"
    end

    it "should accept u as a shortcut of 'go up'" do
      cmd = GoCommand.parse("u", nil)

      cmd.class.should == GoCommand
      cmd.exit.should == "up"
    end
    
    it "should accept down as a shortcut of 'go down'" do
      cmd = GoCommand.parse("down", nil)

      cmd.class.should == GoCommand
      cmd.exit.should == "down"
    end

    it "should accept d as a shortcut of 'go down'" do
      cmd = GoCommand.parse("d", nil)

      cmd.class.should == GoCommand
      cmd.exit.should == "down"
    end

  end

  context "When executing" do
    it "should send a leave event to the current location" do
      character = Build.a_character
      location = mock.as_null_object
      character.move_to(location)
      cmd = GoCommand.new(character, "east")

      location.should_receive(:character_leaving).
              with(character,"east")

      cmd.execute
    end
  end
end