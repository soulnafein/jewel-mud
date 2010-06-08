class Character
  attr_reader :name, :password, :location, :session,
              :description, :inventory, :body
  attr_writer :body

  def initialize(name, session=nil, password=nil, description=nil)
    @name, @session, @password, @description =
            name, session, password, description
    @inventory = Inventory.new
    @body = HumanBody.new
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
    ['@name', '@password', '@description', '@inventory']
  end

  def description_for(character)
    output = "Looking at #{self.name}\n"
    output << @description.to_s
    output << body.description
  end

  def look(target)
    send_to_player(target.description_for(self))
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
      @inventory.add_item item
      notify_player_and_location("You get #{item.description.downcase}",
                                 "#{self.name} gets #{item.description.downcase} from the floor")
    rescue ItemNotAvailable
      @session.write("There is no '#{item_name}' here")
    end
  end

  def drop(item_name)
    begin
      item = @inventory.pick_item(item_name)
      @location.add_item(item)
      notify_player_and_location("You put #{item.description.downcase} on the floor",
                                 "#{self.name} puts #{item.description.downcase} on the floor")
    rescue ItemNotAvailable
      @session.write("You don't have it")
    end
  end

  def print_inventory
    @session.write(@inventory.display)
  end

  def print_equipment
    @session.write(@body.print_equipment) 
  end

  def wear(item_name)
    begin
      item = @inventory.pick_item(item_name)
      @body.wear_garment(item)
      item_description = item.description_for(self)
      notify_player_and_location("You wear #{item_description} on your #{item.wearable_on}",
                                 "#{self.name} wears #{item_description} on the #{item.wearable_on}")
    rescue ItemNotAvailable
      @session.write("You don't have it")
    rescue BodyPartOccupied => e
      @session.write(e.message)
    end
  end

  def take_off(item_name)
    begin
      item = @body.pick_garment(item_name)
      @inventory.add_item(item)
      item_description = item.description_for(self)
      notify_player_and_location("You take off #{item_description}",
                               "#{self.name} takes #{item_description} off")
    rescue ItemNotAvailable
      @session.write("You don't have it")      
    end
  end

  private
  def notify_player_and_location(message_for_player, message_for_location)
    send_to_player(message_for_player)
    @location.send_to_all_except(self, message_for_location)
  end
end