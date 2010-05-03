require "spec/spec_helper"

describe GetCommand do
  context "When parsing a valid input" do
    it "should create a new go command" do
      cmd = GetCommand.parse("get shoes", nil, nil)

      cmd.class.should == GetCommand
      cmd.item == "shoes"
    end

    it "should ignore case of command" do
      cmd = GetCommand.parse("gEt shOes", nil, nil)

      cmd.class.should == GetCommand
      cmd.item == "shoes"
    end

    it "should ignore 'get' appearing in other contexts" do
      cmd = GetCommand.parse("say you should GET something else", nil, nil)

      cmd.should be_nil
    end
  end

  context "When executing" do
    it "should raise a get event in the current location" do
      @event_handler = mock
      character = Build.a_character
      cmd = GetCommand.new(character, @event_handler, "shoes")

      @event_handler.should_receive(:add_event).
              with(Event.new(character, character.current_location, :get, :item => "shoes"))


      cmd.execute
    end
  end
end