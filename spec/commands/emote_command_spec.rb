require "spec/spec_helper"

describe EmoteCommand do
  context "When executing a command" do
    before :each do
      @character = Build.a_character
      @location = mock.as_null_object
      @character.move_to(@location)
      @message = "licks her finger"
      @cmd = EmoteCommand.new(@character, @message)
    end

    it "should add an emote event to the room" do
      @location.should_receive(:notify_all_characters_except).
              with(@character, "David licks her finger")

      @cmd.execute
    end

    it "should notify character of his emote" do
      @character.should_receive(:notification).
              with("You emote: David licks her finger")
      
      @cmd.execute
    end
  end
end
