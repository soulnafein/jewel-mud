class Exit
  attr_reader :name, :destination, :description, :location

  def initialize(name, destination, description="", location=nil)
    @name, @destination, @description, @location =
            name, destination, description, location
  end

  def let_go(character)
    @destination.let_in(character, @location)
    character.move_to(@destination)
  end
end