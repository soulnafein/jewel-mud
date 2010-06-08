require "spec/spec_helper"

describe ShutdownCommand do
  context "When executing" do
    it "should disconnect a player" do
      session = mock
      character = Character.new("David", session)
      cmd = QuitCommand.new(character)

      session.should_receive(:quit)

      cmd.execute
    end
  end
end