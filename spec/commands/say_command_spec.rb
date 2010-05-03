require "spec/spec_helper"

describe SayCommand do
  context "When parsing input a valid input" do
    it "should create a new say command" do
      cmd = SayCommand.parse("say Hello there!", nil, nil)

      cmd.class.should == SayCommand
      cmd.message.should == "Hello there!"
    end

    it "should ignore case of command" do
      cmd = SayCommand.parse("SaY Hello there!", nil, nil)

      cmd.class.should == SayCommand
      cmd.message.should == "Hello there!"
    end
  end

  context "When executing a command" do
    before :each do
      @character = Build.a_character
      @message = "Hello World!"
      @event_handler = mock.as_null_object
      @cmd = SayCommand.new(@character, @event_handler, @message)
    end

    it "should add a talk event for the room" do
      @event_handler.should_receive(:add_event).
          with(Event.new(@character, @character.current_location, :talk, :message => @message))

      @cmd.execute
    end

    it "should notify character of what he said" do
      @character.should_receive(:notification).with("You said: " + @message)
      
      @cmd.execute
    end
  end
end