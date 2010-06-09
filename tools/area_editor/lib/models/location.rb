class Location
  attr_accessor :title, :description, :coordinate, :exits

  def initialize
    @exits = {}
  end

  def eql?(o)
    o.is_a?(Location) && coordinate == o.coordinate
  end

  def ==(o)
    coordinate == o.coordinate
  end

  def hash
    coordinate.hash
  end
end