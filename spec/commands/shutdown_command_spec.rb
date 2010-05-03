require "spec/spec_helper"

describe ShutdownCommand do
  context "When parsing a valid input" do
    it "should create a new shutdown command" do
      cmd = ShutdownCommand.parse("shutdown", nil, nil)

      cmd.class.should == ShutdownCommand
    end

    it "should ignore case of command" do
      cmd = ShutdownCommand.parse("shuTdowN", nil, nil)

      cmd.class.should == ShutdownCommand
    end

    it "should ignore shutdown appearing in other contexts" do
      cmd = ShutdownCommand.parse("say shutdown", nil, nil)

      cmd.should be_nil
    end
  end

  context "When executing" do
    it "should shutdown game" do
      character = Character.new("David", nil)
      cmd = ShutdownCommand.new(character, nil)

      Game.instance.should_receive(:shutdown)

      cmd.execute
    end
  end
end