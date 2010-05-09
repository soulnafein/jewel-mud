class TelnetSession
  def initialize(socket)
    @socket = socket
  end

  def read
    input = @socket.readline
    input = TelnetFilter.new(@socket).filter_input(input)
    input = adjust_backspace(input)
    input.chomp.strip
  end

  def write(text)
    @socket.print adjust_new_lines(replace_color_tags(text))
  end

  private
  COLOR_CODES = {
          "red" => "\e[31m",
          "blue" => "\e[34m",
          "green" => "\e[32m",
          "yellow" => "\e[33m"
  }

  RESET_CODE = "\e[0m"

  def replace_color_tags(text)
    text.gsub(/\[color=([a-z]+)\]/im){ |m| COLOR_CODES[$1] }.
            gsub(/\[\/color\]/i, RESET_CODE)
  end

  def adjust_new_lines(text)
    text.gsub(/\n/,"\r\n") + "\r\n"
  end

  def adjust_backspace(text)
    return text if not text.include?("\b")
    a_character_followed_by_backspace = Regexp.new("(^|[^\b])\b")
    adjust_backspace text.sub(a_character_followed_by_backspace, "")
  end
end
