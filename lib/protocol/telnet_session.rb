class TelnetSession
  def initialize(socket)
    @socket = socket
    @telnet_filter = TelnetFilter.new(@socket)
    @open = true
  end

  def read
    input = @socket.gets
    return "" if not input
    input = @telnet_filter.filter_input(input)
    input.chomp.strip
  end

  def write(text)
    return if @socket.closed?
    output = @telnet_filter.filter_output(text)
    output = replace_color_tags(output)
    @socket.print output
  end

  def open?
    @open
  end

  def quit
    @socket.write("Bye bye!\n")
    @open = false
    @socket.close_read
  end

  private
  COLOR_CODES = {
          "red" => "\e[31m",
          "blue" => "\e[34m",
          "green" => "\e[32m",
          "yellow" => "\e[33m",
          "cyan" => "\e[36m"
  }

  RESET_CODE = "\e[0m"

  def replace_color_tags(text)
    text.gsub(/\[color=([a-z]+)\]/im){ |m| COLOR_CODES[$1] }.
            gsub(/\[\/color\]/i, RESET_CODE)
  end
end
