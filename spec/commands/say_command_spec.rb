require "spec/spec_helper"

describe SayCommand do
  context "When executing a command" do
    before :each do
      @character = Build.a_character
      @location = mock.as_null_object
      @character.move_to(@location)
      @message = "Hello World!"
      @cmd = SayCommand.new(@character, @message)
    end

    it "should add a talk event for the room" do
      @location.should_receive(:notify_all_characters_except).
              with(@character, "David said: Hello World!" )

      @cmd.execute
    end

    it "should notify character of what he said" do
      @character.should_receive(:notification).with("You said: " + @message)
      
      @cmd.execute
    end
  end
end