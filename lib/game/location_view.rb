class LocationView
  def initialize(observer, characters, items, exits, location)
    @observer, @characters, @items, @exits, @location =
            observer, characters, items, exits, location
  end

  def display
    output = "You see:\n" +
            "[color=red]#{@location.title}[/color]\n" +
            "#{@location.description}"
    other_characters = @characters.except(@observer)
    other_characters.each do |p|
      output += "[color=yellow]#{p.name} is here\n[/color]"
    end
    @items.each do |i|
      output += "#{i.description} is here\n"
    end
    output += @exits.get_list_of_names
    output
  end
end