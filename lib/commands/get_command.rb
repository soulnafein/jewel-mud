class GetCommand
  attr_reader :item

  def initialize(character, *args)
    @character = character
    @item = args.first
  end

  def self.parse(input, character)
    if input =~ /^get ([^ ]+)$/i
      return GetCommand.new(character, $1.downcase)
    end
  end

  def execute
  end
end