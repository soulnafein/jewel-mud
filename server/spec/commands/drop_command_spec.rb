require "spec/spec_helper"

describe DropCommand do
  context "When executing" do
    it "should tell the player to drop an item" do
      character = mock
      character.should_receive(:drop).with("pencil")
      
      DropCommand.new(character, "pencil").execute
    end
  end
end