require "spec/spec_helper"

describe RemoveCommand do
  context "When executing" do
    it "should tell the character to wear an item" do
      character = mock
      character.should_receive(:take_off).with("hat")
      
      RemoveCommand.new(character, "hat").execute
    end
  end
end