class Location
  attr_reader :title, :description, :characters, :uid

  def initialize(uid, title, description)
    @uid, @title, @description = uid, title, description
    @characters = []
    @exits = Exits.new
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

  def notify_all_characters_except(excluded_character, notification)
    @characters.except(excluded_character).each do |character|
      add_event(self, character, :show, :message => notification)
    end
  end

  def on_look(e)
    SightHandler.new.handle_look(e)
  end

  def on_talk(event)
    CommunicationHandler.new.handle_talk(event)
  end

  def on_emote(event)
    EmotesHandler.new.handle_emote(event)
  end

  def on_leave(event)
    MovementHandler.new.handle_leave(event)
  end

  def character_leaving(character, direction)
    exit = @exits.find_by_name(direction)
    raise ExitNotAvailable.new if exit.nil?

    notify_all_characters_except(character, "#{character.name} leaves #{exit.name}.")
    remove_character(character)
    add_event(character, exit.destination, :enter, :origin => self)
  end

  def on_enter(event)
    MovementHandler.new.handle_enter(event)
  end

  def get_entity_description(target)
    exit = @exits.find_by_name(target)
    message = "There isn't anything called '#{target}' here."
    message = exit.description if exit
    message
  end

  def description_for(observer)
    output = "You see:\n" +
            "[color=red]#{title}[/color]\n" +
            "#{description}\n"+
            "People:\n"
    other_characters = @characters.except(observer)
    other_characters.each do |p|
      output += "#{p.name}\n"
    end
    output += @exits.get_list_of_names
    output
  end

  def exit_to(destination)
    @exits.find_by_destination(destination)
  end

end
