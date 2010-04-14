require "spec/spec_helper"

describe TelnetSession do
  before :each do
    @socket = mock
    @telnet_session = TelnetSession.new(@socket)
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
  end

  context "When writing to the socket" do
    it "should deliver same text to socket" do
      @socket.should_receive(:puts).with("Something to write")

      @telnet_session.write("Something to write")
    end

    it "should replace color tags with appropriate VT100 code" do
      @socket.should_receive(:puts).with("\e[31mRed\e[0m and \e[34mBlue\e[0m")

      @telnet_session.write("[color=red]Red[/color] and [color=blue]Blue[/color]")
    end
  end

  def when_input_is(text)
    @socket.should_receive(:readline).and_return(text)
  end

  def result
    @telnet_session.read
  end
end

