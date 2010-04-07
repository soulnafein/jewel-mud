require "spec/spec_helper"

describe InputProcessor do
  context "When parsing input" do
    before :each do
      @a_command = stub(:a_command)
      @another_command = mock(:another_command)
      @the_right_command = mock(:the_right_command)
      @commands = [@a_command, @the_right_command, @another_command ]
      @input_processor = InputProcessor.new(@commands, nil)
    end

    it "should match input against each command" do
      expected_command = SayCommand.new("Hello there!")
      @the_right_command.should_receive(:parse).with("say Hello there!").
              and_return(expected_command)
      @a_command.should_receive(:parse).and_return(nil)


      session = StringIO.new("say Hello there!")

      cmd = @input_processor.parse_input_from_session(session)

      cmd.should == expected_command
    end

    it "should remove trailing spaces from input" do
      expected_command = SayCommand.new("Hello there!")
      session = StringIO.new("  say something with     trailing spaces     ")

      @the_right_command.should_receive(:parse).
              with("say something with     trailing spaces").
              and_return(expected_command)
      @a_command.should_receive(:parse).and_return(nil)

      @input_processor.parse_input_from_session(session)
    end

    it "should raise error if cannot find a command" do
      @commands.each { |c| c.should_receive(:parse).and_return(nil)}

      session = StringIO.new("castigate David")

      invalid_input = lambda { @input_processor.parse_input_from_session(session)}
      invalid_input.should raise_error NoCommandFound
    end
  end
end