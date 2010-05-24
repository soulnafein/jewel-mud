class World
  attr_reader :locations

  def initialize
    @locations = []
    @characters = []
    load_world
    print_memstat
  end

  def print_memstat
    locations = exits = characters = items = 0

    ObjectSpace.each_object do |obj|
      locations += 1 if obj.class == Location
      exits += 1 if obj.class == Exit
      characters += 1 if obj.class == Character
      items += 1 if obj.class == Item
    end

    statistics = """
      --------------------------
              STATISTICS
      --------------------------

        Locations: #{locations}
        Exits: #{exits}
        Characters: #{characters}
        Items: #{items}

      --------------------------
    """
    puts statistics
  end

  def get_character_by_name_and_password(name, password)
    @characters.find { |c| c.name == name and c.password == password }
  end

  def create_new_character(name, session, password, description)
    character = Character.new(name, session, password, description)
    @characters.push(character)
    persist_world
    character
  end

  def persist_world
    File.open( 'db/characters.yaml', 'w' ) do |out|
      YAML.dump(@characters, out )
    end
  end

  def load_world
    entities = YAML.load_file('db/dikuworld.yaml')
    exits = entities.find_all { |e| e.class == Exit}
    @locations = entities.find_all { |e| e.class == Location}
    @locations.each do |location|
      location.instance_variable_set('@exits', Exits.new)
      location.instance_variable_set('@characters', [])
    end
    exits.each do |exit|
      exit.location.add_exit(exit)
    end

    @characters = YAML.load_file('db/characters.yaml')
  end
end