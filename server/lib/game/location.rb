class Location
  attr_reader :title, :description, :characters

  include ItemsContainer

  def initialize(title, description)
    @title, @description = title, description
    @characters = []
    @exits = Exits.new
    initialize_items_container
  end

  def add_exit(exit)
    @exits.add(exit)
  end

  def add_character(character)
    @characters << character
    character.move_to(self)
  end

  def remove_character(character)
    @characters.delete(character)
  end

  def send_to_all_except(excluded_character, notification)
    @characters.except(excluded_character).each do |character|
      character.send_to_player(notification)
    end
  end

  def description_for(observer)
    LocationView.new(observer, @characters, @items, @exits, self).display
  end

  def exit_to(destination)
    @exits.find_by_destination(destination)
  end

  def let_go(character, direction)
    exit = @exits.find_by_name(direction)
    raise ExitNotAvailable if exit.nil?
    exit.let_go(character)
    remove_character(character)
    send_to_all_except(character, "#{character.name} leaves #{exit.name}")
  end

  def let_in(character, origin)
    @characters.push(character)
    exit_to_origin = exit_to(origin)
    if exit_to_origin
      notification = "#{character.name} arrives walking from #{exit_to_origin.name}"
    else
      notification = "#{character.name} appears out of thin air"
    end
    send_to_all_except(character, notification)
  end

  def get_entity_by_name(name)
    entity = @exits.find_by_name(name)
    entity = @characters.find { |c| c.name.downcase == name.downcase } if not entity
    entity = @items.find { |c| c.name.downcase == name.downcase } if not entity
    raise EntityNotAvailable if not entity
    entity
  end

end
