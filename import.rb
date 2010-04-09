require 'yaml'
require 'jewel_mud' 
diku = YAML::load_file('db/dikuworld.yaml')

diku_locations = diku.find_all { |o| o.class == "Room" }


locations = diku_locations.map { |l| Location.new(l.ivars["props"][:id],l.ivars["props"][:name], l.ivars["props"][:desc]) }

diku_exits = diku.find_all { |o| o.class == Exit }
diku_exits.each_with_index do |x, i|
  props = x.instance_eval { @props }
  destination = locations.find { |l| l.instance_eval { @uid } == props[:to_room]}
  a_exit = Exit.new( props[:name], destination, props[:desc])
  location = locations.find { |l| l.instance_eval { @uid } == props[:location] }
  location.add_exit(a_exit)
  puts i
end

File.open( 'db/mydiku.yaml', 'w' ) do |out|
  YAML.dump(locations, out) 
end

puts locations[0].to_yaml 

