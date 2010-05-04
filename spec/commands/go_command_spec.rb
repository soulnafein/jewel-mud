require "spec/spec_helper"

describe GoCommand do
  context "When executing" do
    it "should tell the character to go in a direction" do
      character = mock
      character.should_receive(:go).with("east")
      
      GoCommand.new(character, "east").execute
    end
  end
end