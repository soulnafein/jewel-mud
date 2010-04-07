class World
  attr_reader :locations

  def initialize
    @locations =
            [
              Location.new(1,
                  "A room in the middle of nowhere",
                  "It's big and it's in the middle of nowhere"),
              Location.new(2,
                           "A room next to the other one",
                           "It's another big room")

            ]
    @locations[0].add_exit(Exit.new("east", @locations[1]))
    @locations[1].add_exit(Exit.new("west", @locations[0]))
  end

  def add_player(player)
    @locations.first.add_player player
  end

  def get_location_for_id(location_id)
    @locations.find { |loc| loc.uid == location_id }
  end
end