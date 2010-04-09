require "spec/spec_helper"

describe GoCommand do
  context "When parsing a valid input" do
    it "should create a new go command" do
      cmd = GoCommand.parse("go east")

      cmd.class.should == GoCommand
      cmd.args.first.should == "east"
    end

    it "should ignore case of command" do
      cmd = GoCommand.parse("gO eaSt")

      cmd.class.should == GoCommand
      cmd.args.first.should == "east"
    end

    it "should ignore 'go' appearing in other contexts" do
      cmd = GoCommand.parse("say you should GO somewhere else")

      cmd.should be_nil
    end
  end

  context "Shortcuts" do
    it "should accept west as a shortcut of 'go west'" do
      cmd = GoCommand.parse("west")

      cmd.class.should == GoCommand
      cmd.args.first.should == "west"
    end

    it "should accept w as a shortcut of 'go west'" do
      cmd = GoCommand.parse("w")

      cmd.class.should == GoCommand
      cmd.args.first.should == "west"
    end

    it "should accept east as a shortcut of 'go east'" do
      cmd = GoCommand.parse("east")

      cmd.class.should == GoCommand
      cmd.args.first.should == "east"
    end

    it "should accept e as a shortcut of 'go east'" do
      cmd = GoCommand.parse("e")

      cmd.class.should == GoCommand
      cmd.args.first.should == "east"
    end

    it "should accept north as a shortcut of 'go north'" do
      cmd = GoCommand.parse("north")

      cmd.class.should == GoCommand
      cmd.args.first.should == "north"
    end

    it "should accept n as a shortcut of 'go north'" do
      cmd = GoCommand.parse("n")

      cmd.class.should == GoCommand
      cmd.args.first.should == "north"
    end

    it "should accept south as a shortcut of 'go south'" do
      cmd = GoCommand.parse("south")

      cmd.class.should == GoCommand
      cmd.args.first.should == "south"
    end

    it "should accept s as a shortcut of 'go south'" do
      cmd = GoCommand.parse("s")

      cmd.class.should == GoCommand
      cmd.args.first.should == "south"
    end

    it "should accept up as a shortcut of 'go up'" do
      cmd = GoCommand.parse("up")

      cmd.class.should == GoCommand
      cmd.args.first.should == "up"
    end

    it "should accept u as a shortcut of 'go up'" do
      cmd = GoCommand.parse("u")

      cmd.class.should == GoCommand
      cmd.args.first.should == "up"
    end
    
    it "should accept down as a shortcut of 'go down'" do
      cmd = GoCommand.parse("down")

      cmd.class.should == GoCommand
      cmd.args.first.should == "down"
    end

    it "should accept d as a shortcut of 'go down'" do
      cmd = GoCommand.parse("d")

      cmd.class.should == GoCommand
      cmd.args.first.should == "down"
    end

  end

  context "When executing" do
    it "should send a leave event to the current location" do
      character = Build.a_character
      cmd = GoCommand.new("east")

      Game.instance.should_receive(:add_event).
              with(character, character.current_location, :leave, :exit => "east")

      cmd.execute_as(character)
    end
  end
end