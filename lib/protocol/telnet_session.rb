class TelnetSession
  def initialize(socket)
    @socket = socket
  end

  def read
    input = @socket.readline
    input = TelnetFilter.new(@socket).filter_input(input)
    input.chomp.strip
  end

  def write(text)
    @socket.puts replace_color_tags(text)
  end

  private
  COLOR_CODES = {
          "red" => "\e[31m",
          "blue" => "\e[34m",
          "green" => "\e[32m"
  }

  RESET_CODE = "\e[0m"

  def replace_color_tags(text)
    text.
            gsub(/\[color=([a-z]+)\]/im) do |m|
      COLOR_CODES[$1]
    end.
            gsub(/\[\/color\]/i, RESET_CODE)
  end
end
