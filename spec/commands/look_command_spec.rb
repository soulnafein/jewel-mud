require "spec/spec_helper"

describe LookCommand do
  context "When parsing a look command without arguments" do
    it "should create a new look command" do
      cmd = LookCommand.parse("look", nil, nil)

      cmd.class.should == LookCommand
    end

    it "should ignore case of command" do
      cmd = LookCommand.parse("LooK", nil, nil)

      cmd.class.should == LookCommand
    end

    it "should ignore 'look' appearing in other contexts" do
      cmd = LookCommand.parse("say you should LOOK above you", nil, nil)

      cmd.should be_nil
    end

    it "should capture the object looked" do
      cmd = LookCommand.parse("look east", nil, nil)

      cmd.class.should == LookCommand
      cmd.target.should == "east"
    end
  end

  context "When executing" do
    it "should shutdown game" do
      event_handler = mock
      character = Character.new("David", nil)
      cmd = LookCommand.new(character, event_handler, "east")

      character.should_receive(:look).
              with("east")

      cmd.execute
    end
  end
end