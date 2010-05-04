class GoCommand
  attr_reader :exit
  
  def initialize(character, *args)
    @character = character
    @exit = args.first
  end

  COMMON_EXITS = ["north", "south", "east", "west", "up", "down"]

  def self.parse(input, character)
    if input =~ /^go ([^ ]+)$/i
      return GoCommand.new(character, $1.downcase)
    end

    COMMON_EXITS.each do |direction|
      direction_first_letter = direction[0...1]

      if input.downcase == direction || input.downcase == direction_first_letter
        return GoCommand.new(character, direction.downcase)
      end
    end
    nil
  end

  def execute
    begin
      @character.current_location.character_leaving(@character, @exit)
    rescue ExitNotAvailable
      @character.notification("You can't go in that direction.")
    end
  end
end