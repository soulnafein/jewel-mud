require "spec/spec_helper"

describe GoCommand do
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