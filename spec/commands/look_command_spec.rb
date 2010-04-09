require "spec/spec_helper"

describe LookCommand do
  context "When parsing a look command without arguments" do
    it "should create a new look command" do
      cmd = LookCommand.parse("look")

      cmd.class.should == LookCommand
    end

    it "should ignore case of command" do
      cmd = LookCommand.parse("LooK")

      cmd.class.should == LookCommand
    end

    it "should ignore 'look' appearing in other contexts" do
      cmd = LookCommand.parse("say you should LOOK above you")

      cmd.should be_nil
    end

    it "should capture the object looked" do
      cmd = LookCommand.parse("look east")

      cmd.class.should == LookCommand
      cmd.target.should == "east"
    end
  end

  context "When executing" do
    it "should shutdown game" do
      player = Player.new("David", nil)
      cmd = LookCommand.new("east")

      Game.instance.should_receive(:add_event).
              with(player, player.current_location, :look, :target => "east")

      cmd.execute_as(player)
    end
  end
end