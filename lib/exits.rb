class Exits
  def initialize
    @exits = []
  end

  def find_by_name(name)
    @exits.find { |exit| exit.name == name}
  end

  def find_by_destination(destination)
    @exits.find { |exit| exit.destination == destination}
  end

  def add(exit)
    @exits << exit
  end

  def get_list_of_names
    @exits.map {|exit| exit.name }.join(", ")
  end
end