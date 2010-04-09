class GoCommand
  attr_reader :args
  
  def initialize(*args)
    @args = args
    @exit = @args.first
  end

  COMMON_EXITS = ["north", "south", "east", "west", "up", "down"]

  def self.parse(input)
    if input =~ /^go ([^ ]+)$/i
      return GoCommand.new($1.downcase)
    end

    COMMON_EXITS.each do |direction|
      direction_first_letter = direction[0...1]

      if input.downcase == direction || input.downcase == direction_first_letter
        return GoCommand.new(direction.downcase)
      end
    end
    nil
  end

  def execute_as(character)
    Game.instance.add_event(character, character.current_location, :leave, :exit => @exit)
  end
end