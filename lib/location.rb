class Location
  attr_reader :title, :description, :players, :uid

  def initialize(uid, title, description)
    @uid, @title, @description = uid, title, description
    @players = []
    @exits = []
  end

  def add_exit(exit)
    @exits << exit
  end

  def add_player(player)
    @players << player
    player.move_to(self)
  end

  def remove_player(player)
    @players.delete(player)
  end

  def get_exit(direction)
    @exits.find { |d| d.name == direction }
  end

  def on_look(e)
    observer = e.from
    output = "You see:\n\r" +
             "#{title}\n\r\n\r" +
             "#{description}\n\r\n\r"+
             "People:\n\r"
    other_players = @players.except(observer)
    other_players.each do |p|
      output += "#{p.name}\n\r"
    end
    output += "\n\r"
    add_event(self, observer, :show, :message => output)
  end

  def on_talk(event)
    @players.except(event.from).each do |player|
      notification = "#{event.from.name} said: #{event.args[:message]}"
      add_event(self, player, :show, :message => notification)
    end
  end

  def on_leave(event)
    exit = get_exit(event.args[:exit])
    remove_player(event.from)
    add_event(event.from, exit.destination, :enter, :origin => self) if exit
    @players.each do |player|
      add_event(self, player, :show, :message => "#{event.from.name} leaves #{exit.name}")
    end
  end

  def on_enter(event)
    add_player(event.from)
    origin = event.args[:origin]
    exit = @exits.find { |e| e.destination == origin }

    @players.except(event.from).each do |player|
      notification = "#{event.from.name} appears out of thin air"
      notification = "#{event.from.name} arrives walking from #{exit.name}" if exit
      add_event(self, player, :show, :message => notification)
    end

    add_event(event.from, self, :look)
  end
end