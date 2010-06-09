class Area
  def initialize(name, width, height)
    @locations = []
    @name, @width, @height = name, width, height
  end

  attr_reader :name, :width, :height

  def add_or_replace_location(location)
    @locations.delete(location)
    @locations.push(location)
  end

  def get_location_at_coordinate(coordinate)
    @locations.find { |l| l.coordinate == coordinate }
  end
end