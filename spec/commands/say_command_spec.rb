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
      @event_handler = mock.as_null_object
    end

    it "should add a talk event for the room" do
      @event_handler.should_receive(:add_event).
          with(Event.new(@character, @character.current_location, :talk, :message => @message))

      @cmd.execute_as(@character, @event_handler)
    end

    it "should notify character of what he said" do
      @character.should_receive(:notification).with("You said: " + @message)
      
      @cmd.execute_as(@character, @event_handler)
    end
  end
end