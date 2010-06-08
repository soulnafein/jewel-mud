class CommandFactory
  attr_accessor :aliases

  def initialize(game)
    @game = game
    @aliases = {}
  end

  def parse(input, character)
    return DoNothing.new if input.empty?
    command_name, arguments = split_input(input)
    command_class = get_command_by_name(command_name)
    command_class.new(character, arguments, @game)
  end

  private
  def get_command_by_name(name)
    command_class = ObjectSpace.each_object.find do |o|
      o.class == Class and o.name == "#{name.capitalize}Command"
    end
    command_class || NoCommandFound
  end

  def split_input(input)
    input = parse_through_alias_matcher(input)
    input =~ /^(\w+)(.*)/i
    return $1, $2.strip
  end

  def parse_through_alias_matcher(input)
    input =~ /^(\w+)(.*)/i
    if @aliases.has_key?($1.to_s.downcase)
      return input.gsub(/^(\w+)/, @aliases[$1.downcase])
    end
    input
  end
end