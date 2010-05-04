require "spec/spec_helper"

describe LookCommand do
  context "When executing" do
    it "should shutdown game" do
      character = Character.new("David", nil)
      cmd = LookCommand.new(character, "east")

      character.should_receive(:look).
              with("east")

      cmd.execute
    end
  end
end