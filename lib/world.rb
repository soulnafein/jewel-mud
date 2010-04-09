class World
  attr_reader :locations

  def initialize
    @locations = YAML.load_file('db/dikuworld.yaml')
  end
end