class TelnetFilter
  include TelnetCodes

  def initialize(socket)
    @socket = socket
  end

  def filter_input(input)
    input = remove_bare_line_feeds input
    input = remove_bare_carriage_returns input
    input = remove_bare_nuls input
    input = adjust_backspace(input)
    handle_options input
  end

  def filter_output(output)
    adjust_new_lines(output)  
  end

  private
  def adjust_new_lines(text)
    text.gsub(/\n/,"\r\n") + "\r\n"
  end

  def adjust_backspace(text)
    return text if not text.include?("\b")
    a_character_followed_by_backspace = Regexp.new("(^|[^\b])\b")
    adjust_backspace text.sub(a_character_followed_by_backspace, "")
  end

  LF_NOT_PRECEDED_BY_CR = Regexp.new("(^|[^#{CR}])#{LF}")
  def remove_bare_line_feeds(input)
    input.gsub(LF_NOT_PRECEDED_BY_CR, '\1')
  end

  CR_FOLLOWED_BY_A_NUL = Regexp.new("#{CR}#{NUL}")
  def remove_bare_carriage_returns(input)
    input.gsub(CR_FOLLOWED_BY_A_NUL, '')
  end

  JUST_A_NULL = Regexp.new("#{NUL}")
  def remove_bare_nuls(input)
    input.gsub(JUST_A_NULL, '')
  end

  def handle_options(input)
    while there_is_a_iac_in input
      if input.sub!(Regexp.new("(^|[^#{IAC}])#{IAC}[#{DO}#{DONT}](.)"), '\1')
        @socket.print "#{IAC+WONT}#{$2}"
      elsif input.sub!(Regexp.new("(^|[^#{IAC}])#{IAC}[#{WILL}#{WONT}](.)"), '\1')
        @socket.print "#{IAC+DONT}#{$2}"
      elsif input.sub!(Regexp.new("(^|[^#{IAC}])#{IAC}#{AYT}"), "\\1")
        @socket.puts "JewelMUD is still here"
      elsif input.sub!(Regexp.new("(^|[^#{IAC}])#{IAC}[^#{IAC}]"), "\\1")
      else
        input.sub!(Regexp.new("[#{IAC}]"), "")
      end
    end
    input
  end

  def there_is_a_iac_in(input)
    input.index("#{IAC}")
  end

end