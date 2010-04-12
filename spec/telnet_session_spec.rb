require "spec/spec_helper"

describe TelnetSession do
  context "When reading input from socket" do
    it "should remove new lines" do
      socket = mock
      socket.should_receive(:readline).and_return("A line from socket\n")

      telnet_session = TelnetSession.new(socket)

      telnet_session.read.should == "A line from socket"
    end

    it "should remove trailing spaces" do
      socket = mock
      socket.should_receive(:readline).and_return("  say something with     trailing spaces     ")

      telnet_session = TelnetSession.new(socket)

      telnet_session.read.should == "say something with     trailing spaces"
    end
  end

  context "When writing to the socket" do
    it "should deliver same text to socket" do
      socket = mock
      socket.should_receive(:puts).with("Something to write")

      telnet_session = TelnetSession.new(socket)

      telnet_session.write("Something to write")
    end
  end
end

