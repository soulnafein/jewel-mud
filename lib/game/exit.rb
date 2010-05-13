class Exit
  attr_reader :name, :destination, :location

  def initialize(name, destination, description="", location=nil)
    @name, @destination, @description, @location =
            name, destination, description, location
  end

  def let_go(character)
    @destination.let_in(character, @location)
    character.move_to(@destination)
    character.look(@destination)
  end

  def description_for(character)
    @description
  end
end