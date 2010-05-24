require "spec/spec_helper"

describe TelnetSession do

  before :each do
    @socket = mock.as_null_object
    @socket.stub(:closed?).and_return(false)
    @telnet_session = TelnetSession.new(@socket)
    @a_option = 42.chr
    @iac = TelnetCodes::IAC
    @do = TelnetCodes::DO
    @dont = TelnetCodes::DONT
    @wont = TelnetCodes::WONT
    @will = TelnetCodes::WILL
    @ayt = TelnetCodes::AYT
  end

  context "When reading input from socket" do
    it "should remove new lines and carriage returns" do
      when_input_is "A line from socket\n\r"
      result.should == "A line from socket"
    end

    it "should remove trailing spaces" do
      when_input_is "  say something with     trailing spaces     "
      result.should == "say something with     trailing spaces"
    end

    it "should ignore bare LF" do
      when_input_is "Line with \n line feed alone\r\n"
      result.should == "Line with  line feed alone"
    end

    it "should ignore bare CR" do
      when_input_is "Line with \r\0 line feed alone\r\n"
      result.should == "Line with  line feed alone"
    end

    it "should ignore bare NUL" do
      when_input_is "Line with \0 line feed alone\r\n"
      result.should == "Line with  line feed alone"
    end

    it "should answer DOs with WONT" do
      when_input_is "A line with a double IAC followed by a DO #{@iac+@iac}#{@iac+@do+@a_option}"
      @socket.should_receive(:print).with("#{@iac+@wont+@a_option}")
      result.should == "A line with a double IAC followed by a DO"
    end

    it "should answer DONTs with WONT" do
      when_input_is "A line with a double IAC followed by a DONT #{@iac+@iac}#{@iac+@dont+@a_option}"
      @socket.should_receive(:print).with("#{@iac+@wont+@a_option}")
      result.should == "A line with a double IAC followed by a DONT"
    end

    it "should answer WILLs with DONT" do
      when_input_is "A line with a double IAC followed by a WILL #{@iac+@iac}#{@iac+@will+@a_option}"
      @socket.should_receive(:print).with("#{@iac+@dont+@a_option}")
      result.should == "A line with a double IAC followed by a WILL"
    end

    it "should answer WONTs with DONT" do
      when_input_is "A line with a double IAC followed by a WONT #{@iac+@iac}#{@iac+@wont+@a_option}"
      @socket.should_receive(:print).with("#{@iac+@dont+@a_option}")
      result.should == "A line with a double IAC followed by a WONT"
    end

    it "should reply to Are you there questions" do
      when_input_is "Some kind of message #{@iac+@ayt} with are you there inside"
      @socket.should_receive(:puts).with("JewelMUD is still here")
      result.should == "Some kind of message  with are you there inside"
    end

    it "should ignore other telnet codes" do
      when_input_is "Messages with random codes #{@iac+50.chr+@iac+103.chr+@iac+103.chr}"
      @socket.should_not_receive(:puts)
      result.should == "Messages with random codes"
    end

    it "should manage backspace correctly" do
      when_input_is "\bDavol\b\bid"

      result.should == "David"
    end
  end

  context "When writing to the socket" do
    it "should not receive print when socket is closed" do
      @socket.stub(:closed?).and_return(true)
      @socket.should_not_receive(:print)

      @telnet_session.write("Something to write")
    end

    it "should add correct new line at the end" do
      @socket.should_receive(:print).with("Something to write\r\n")

      @telnet_session.write("Something to write")
    end

    it "should replace color tags with appropriate VT100 code" do
      @socket.should_receive(:print).with("\e[31mRed\e[0m and \e[34mBlue\e[0m\r\n")

      @telnet_session.write("[color=red]Red[/color] and [color=blue]Blue[/color]")
    end

    it "should replace line feed to the right telnet combination CR + LF" do
      @socket.should_receive(:print).with("New lines here \r\n here \r\n and here\r\n")

      @telnet_session.write("New lines here \n here \n and here")
    end

    it "should work" do
      Regexp.new("#{TelnetCodes::DO}")
    end
  end

  def when_input_is(text)
    @socket.should_receive(:readline).and_return(text)
  end

  def result
    @telnet_session.read
  end
end

