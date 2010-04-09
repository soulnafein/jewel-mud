require "spec/spec_helper"

describe SayCommand do
  context "When parsing input a valid input" do
    it "should create a new say command" do
      cmd = SayCommand.parse("say Hello there!")

      cmd.class.should == SayCommand
      cmd.args.should == ["Hello there!"]
    end

    it "should ignore case of command" do
      cmd = SayCommand.parse("SaY Hello there!")

      cmd.class.should == SayCommand
      cmd.args.should == ["Hello there!"]
    end
  end

  context "When executing a command" do
    before :each do
      @character = Build.a_character
      @message = "Hello World!"
      @cmd = SayCommand.new(@message)
    end

    it "should add a talk event for the room" do
      Game.instance.should_receive(:add_event).
          with(@character, @character.current_location, :talk, :message => @message)

      @cmd.execute_as(@character)
    end

    it "should notify character of what he said" do
      @character.should_receive(:notification).with("You said: " + @message)
      
      @cmd.execute_as(@character)
    end
  end
end