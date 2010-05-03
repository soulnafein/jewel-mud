class GoCommand
  attr_reader :exit
  
  def initialize(character, event_manager, *args)
    @character, @event_manager = character, event_manager
    @exit = args.first
  end

  COMMON_EXITS = ["north", "south", "east", "west", "up", "down"]

  def self.parse(input, character, event_manager)
    if input =~ /^go ([^ ]+)$/i
      return GoCommand.new(character, event_manager, $1.downcase)
    end

    COMMON_EXITS.each do |direction|
      direction_first_letter = direction[0...1]

      if input.downcase == direction || input.downcase == direction_first_letter
        return GoCommand.new(character, event_manager, direction.downcase)
      end
    end
    nil
  end

  def execute
    @event_manager.add_event(Event.new(@character, @character.current_location, :leave, :exit => @exit))
  end
end