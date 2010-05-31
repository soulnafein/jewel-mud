class LookCommand
  attr_reader :target
  
  def initialize(character, *args)
    @character = character
    @location = character.location
    @target_name = args[0]
  end

  def execute
    begin
      @character.look(get_target(@target_name))
    rescue EntityNotAvailable
      @character.send_to_player("You can't see '#{@target_name}' here")
    end
  end

  private
  def get_target(target_name)
    return @location if target_name.empty?
    @location.get_entity_by_name(target_name)
  end
end