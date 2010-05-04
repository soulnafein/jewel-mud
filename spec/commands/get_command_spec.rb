require "spec/spec_helper"

describe GetCommand do
  context "When parsing a valid input" do
    it "should create a new go command" do
      cmd = GetCommand.parse("get shoes", nil)

      cmd.class.should == GetCommand
      cmd.item == "shoes"
    end

    it "should ignore case of command" do
      cmd = GetCommand.parse("gEt shOes", nil)

      cmd.class.should == GetCommand
      cmd.item == "shoes"
    end

    it "should ignore 'get' appearing in other contexts" do
      cmd = GetCommand.parse("say you should GET something else", nil)

      cmd.should be_nil
    end
  end

  context "When executing" do
    it "should raise a get event in the current location" do
    end
  end
end