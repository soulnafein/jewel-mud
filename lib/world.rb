class World
  attr_reader :locations

  def initialize
    @locations = YAML.load_file('db/dikuworld.yaml')
    print_memstat
  end

  def print_memstat
    locations = exits = 0

    ObjectSpace.each_object do |obj|
      locations += 1 if obj.class == Location
      exits += 1 if obj.class == Exit
    end

    statistics = """
      --------------------------
              STATISTICS
      --------------------------

        Locations: #{locations}
        Exits: #{exits}

      --------------------------
    """
    puts statistics
  end
end