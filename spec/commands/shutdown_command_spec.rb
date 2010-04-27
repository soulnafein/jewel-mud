require "spec/spec_helper"

describe ShutdownCommand do
  context "When parsing a valid input" do
    it "should create a new shutdown command" do
      cmd = ShutdownCommand.parse("shutdown")

      cmd.class.should == ShutdownCommand
    end

    it "should ignore case of command" do
      cmd = ShutdownCommand.parse("shuTdowN")

      cmd.class.should == ShutdownCommand
    end

    it "should ignore shutdown appearing in other contexts" do
      cmd = ShutdownCommand.parse("say shutdown")

      cmd.should be_nil
    end
  end

  context "When executing" do
    it "should shutdown game" do
      character = Character.new("David", nil)
      cmd = ShutdownCommand.new

      Game.instance.should_receive(:shutdown)

      cmd.execute_as(character, nil)
    end
  end
end