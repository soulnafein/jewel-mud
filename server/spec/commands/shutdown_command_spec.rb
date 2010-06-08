require "spec/spec_helper"

describe ShutdownCommand do
  context "When executing" do
    it "should shutdown game" do
      game = mock
      character = Character.new("David", nil)
      cmd = ShutdownCommand.new(character, "", game)

      game.should_receive(:shutdown_game)

      cmd.execute
    end
  end
end