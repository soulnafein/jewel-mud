require 'jewel_mud'

class Exits
  def contains?(exit)
    @exits.include?(exit)
  end
end
class Location
  def contains?(exit)
    @exits.contains?(exit)
  end
end
class Exit
  def location=(value)
    @location = value
  end
end
locations = YAML::load_file('db/dikuworld.yaml')
exits = locations.map { |l| l.instance_variable_get('@exits').instance_variable_get('@exits') }.flatten
exits.each { |e| location = locations.find { |l| l.contains?(e) }; e.location = location;}
class Location
  def to_yaml_properties
    @items = []
    ['@title','@description','@items']
  end
end
entities = locations + exits
File.open( 'db/new_diky.yaml', 'w' ) do |out|
  YAML.dump(entities, out) 
end
