class World
  attr_reader :locations

  def initialize
    @locations = YAML.load_file('db/dikuworld.yaml')
    @characters = []
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

  def get_character_by_name_and_password(name, password)
    @characters.find { |c| c.name == name and c.password == password }
  end

  def create_new_character(name, session, password)
    character = Character.new(name, session, password)
    @characters.push(character)
    character
  end
end