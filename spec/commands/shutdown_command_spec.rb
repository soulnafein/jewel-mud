require "spec/spec_helper"

describe ShutdownCommand do
  context "When executing" do
    it "should shutdown game" do
      character = Character.new("David", nil)
      cmd = ShutdownCommand.new(character, nil)

      Game.instance.should_receive(:shutdown)

      cmd.execute
    end
  end
end