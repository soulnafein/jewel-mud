class Exits
  def initialize(exits = [])
    @exits = exits
  end

  def find_by_name(name)
    @exits.find { |exit| exit.name.downcase == name.downcase}
  end

  def find_by_destination(destination)
    @exits.find { |exit| exit.destination == destination}
  end

  def add(exit)
    @exits << exit
  end

  def get_list_of_names
    exit_names = @exits.map {|exit| exit.name }

    return "" if exit_names.empty?

    if exit_names.size == 1
      return description_for_single_exit(exit_names)
    end

    description_for_multiple_exits(exit_names)
  end

  def description_for_single_exit(exit_names)
    "[color=green]You see only one exit leading #{exit_names.first}[/color]\n"
  end

  def description_for_multiple_exits(exit_names)
    names_separated = exit_names[0..-2].join(", ") + " and " + exit_names[-1]
    "[color=green]You see exits leading #{names_separated}.[/color]\n"
  end
end