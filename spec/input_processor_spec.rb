require "spec/spec_helper"

describe InputProcessor do
  context "When parsing input" do
    before :each do
      @a_command = stub(:a_command)
      @another_command = mock(:another_command)
      @the_right_command = mock(:the_right_command)
      @commands = [@a_command, @the_right_command, @another_command ]
      @command_manager = mock.as_null_object
      @input_processor = InputProcessor.new(@commands, @command_manager)
    end

    it "should match input against each command" do
      expected_command = SayCommand.new(nil, nil, "Hello there!")
      socket = StringIO.new("say Hello there!")
      session = TelnetSession.new(socket)
      character = Character.new("David", session)
      @the_right_command.should_receive(:parse).with("say Hello there!",character).
              and_return(expected_command)
      @a_command.should_receive(:parse).and_return(nil)


      cmd = @input_processor.parse_input_from_session(character)

      cmd.should == expected_command
    end

    it "should raise error if cannot find a command" do
      @commands.each { |c| c.should_receive(:parse).and_return(nil)}

      socket = StringIO.new("castigate David")
      session = TelnetSession.new(socket)
      character = Character.new("David", session)

      invalid_input = lambda { @input_processor.parse_input_from_session(character)}
      invalid_input.should raise_error NoCommandFound
    end
  end
end