require "spec/spec_helper"

describe EmoteCommand do
  context "When parsing input a valid input" do
    it "should create a new emote command" do
      cmd = EmoteCommand.parse("emote licks her finger")

      cmd.class.should == EmoteCommand
      cmd.args.should == ["licks her finger"]
    end

    it "should ignore case of command" do
      cmd = EmoteCommand.parse("EMOTE licks her finger")

      cmd.class.should == EmoteCommand
      cmd.args.should == ["licks her finger"]
    end
  end

  context "When executing a command" do
    before :each do
      @character = Build.a_character
      @message = "licks her finger"
      @cmd = EmoteCommand.new(@message)
    end

    it "should add an emote event to the room" do
      Game.instance.should_receive(:add_event).
          with(@character, @character.current_location, :emote, :message => @message)

      @cmd.execute_as(@character)
    end

    it "should notify character of his emote" do
      @character.should_receive(:notification).with("You emote: #{@character.name} #{@message}")
      
      @cmd.execute_as(@character)
    end
  end
end
