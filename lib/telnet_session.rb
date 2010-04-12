class TelnetSession
  def initialize(socket)
    @socket = socket
  end

  def read
    @socket.readline.chomp.strip
  end

  def write(text)
    @socket.puts text
  end
end