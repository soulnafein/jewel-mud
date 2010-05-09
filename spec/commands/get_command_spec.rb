require "spec/spec_helper"

describe GetCommand do
  context "When executing" do
    it "should tell the player to get an item" do
      character = mock
      character.should_receive(:get).with("pencil")
      
      GetCommand.new(character, "pencil").execute
    end
  end
end