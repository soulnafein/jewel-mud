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

  context "When executing" do
    it "should add a leave event for the room" do
      player = Build.a_player
      cmd = GoCommand.new("east")

      Game.instance.should_receive(:add_event).
              with(player, player.current_location, :leave, :exit => "east")

      cmd.execute_as(player)
    end
  end
end