class TelnetSession
  def initialize(socket)
    @socket = socket
  end

  def read
    input = @socket.readline
    input = telnet_filter input
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

  include TelnetCodes
  def telnet_filter(input)
    input = remove_bare_line_feeds input
    input = remove_bare_carriage_returns input
    input = remove_bare_nuls input
  end

  def remove_bare_line_feeds(input)
    regexp = Regexp.new("(^|[^#{CR}])#{LF}")
    input.gsub(regexp, '\1')
  end

  def remove_bare_carriage_returns(input)
    regexp = Regexp.new("#{CR}#{NUL}")
    input.gsub(regexp, '')
  end

  def remove_bare_nuls(input)
    regexp = Regexp.new("#{NUL}")
    input.gsub(regexp, '')
  end
end
