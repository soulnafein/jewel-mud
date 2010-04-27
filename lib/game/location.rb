class Location
  attr_reader :title, :description, :characters, :uid

  def initialize(uid, title, description)
    @uid, @title, @description = uid, title, description
    @characters = []
    @exits = Exits.new
    @communication_handler = CommunicationHandler.new
    @emotes_handler = EmotesHandler.new
    @sight_handler = SightHandler.new
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
    @sight_handler.handle_look(e)
  end

  def on_talk(event)
    @communication_handler.handle_say(event)
  end

  def on_emote(event)
    @emotes_handler.handle_emote(event)
  end

  def on_leave(event)
    exit = @exits.find_by_name(event.args[:exit])
    if exit.nil? || exit.destination.nil?
      add_event(self, event.from, :show, :message => "You can't go in that direction.") 
    else
      remove_character(event.from)
      add_event(event.from, exit.destination, :enter, :origin => self) if exit
      @characters.each do |character|
        add_event(self, character, :show, :message => "#{event.from.name} leaves #{exit.name}")
      end
    end
  end

  def on_enter(event)
    add_character(event.from)
    origin = event.args[:origin]
    exit = @exits.find_by_destination(origin)


    @characters.except(event.from).each do |character|
      notification = "#{event.from.name} appears out of thin air"
      notification = "#{event.from.name} arrives walking from #{exit.name}" if exit
      add_event(self, character, :show, :message => notification)
    end

    add_event(event.from, self, :look)
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

end
