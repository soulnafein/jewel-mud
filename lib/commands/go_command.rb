class GoCommand
  attr_reader :exit
  
  def initialize(character, *args)
    @character = character
    @exit = args.first
  end

  def execute
    begin
      @character.current_location.character_leaving(@character, @exit)
    rescue ExitNotAvailable
      @character.notification("You can't go in that direction.")
    end
  end
end