class LocationView
  def initialize(observer, characters, items, exits, location)
    @observer, @characters, @items, @exits, @location =
            observer, characters, items, exits, location
  end

  def display
    output = "You see:\n" +
            "[color=red]#{@location.title}[/color]\n" +
            "#{@location.description}"
    output += @exits.get_list_of_names
    other_characters = @characters.except(@observer)
    other_characters.each do |p|
      output += "[color=yellow]#{p.name} is here\n[/color]"
    end
    @items.each do |i|
      output += "[color=yellow]#{i.description.capitalize} is here[/color]\n"
    end
    output
  end
end