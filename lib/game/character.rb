class Character
  attr_reader :name, :password, :location, :session, :description,
              :inventory

  def initialize(name, session=nil, password=nil, description=nil)
    @name, @session, @password, @description =
    name, session, password, description
    @inventory = Inventory.new
  end

  def send_to_player(msg)
    @session.write msg
  end

  def move_to(location)
    @location = location
  end

  def bind_session(session)
    @session = session
  end

  def to_yaml_properties
    ['@name', '@password', '@description','@inventory']
  end

  def look(target="")
    if not target.empty?
      description = @location.get_entity_description(target)
    else
      description = @location.description_for(self)
    end

    send_to_player(description)
  end

  def emote(emote_description)
    emote_message = "#{@name} #{emote_description}"
    @session.write "You emote: #{emote_message}"
    @location.send_to_all_except(self, emote_message)
  end

  def go(direction)
    begin
      @location.let_go(self, direction)
    rescue ExitNotAvailable
      @session.write "You can't go in that direction."
    end
  end

  def say(message)
    send_to_player("[color=cyan]You say '[/color]#{message}[color=cyan]'[/color]")
    notification = "[color=cyan]#{self.name} says '[/color]#{message}[color=cyan]'[/color]"
    @location.send_to_all_except(self, notification)
  end

  def get(item_name)
    begin
      item = @location.pick_item(item_name)
      @location.send_to_all_except(self, "#{self.name} gets #{item.description.downcase} from the floor") #TODO: some responsibilty issue. Location should do this.
      @inventory.add item
      @session.write("You get #{item.description.downcase}")
    rescue ItemNotAvailable
      @session.write("There is no '#{item_name}' here")
    end
  end

  def drop(item_name)
    begin
      item = @inventory.pick(item_name)
      @location.add_item(item)
      @location.send_to_all_except(self, "#{self.name} puts #{item.description.downcase} on the floor") #TODO: some responsibilty issue. Location should do this.
      @session.write("You put #{item.description.downcase} on the floor")
    rescue ItemNotAvailable
      @session.write("You don't have that item")
    end
  end

  def print_inventory()
    @session.write(@inventory.display)
  end
end