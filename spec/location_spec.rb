require "spec/spec_helper"

describe Location do
  context "When looked by someone" do
    it "should send a show event to the observer" do
      location = Location.new(1, "A title", "A description")
      location.add_player(Build.a_player)

      observer = Player.new("Observer", nil)

      look_event = Event.new(observer, location, :look)

      expected_description = "You see:\n\r" +
              "A title\n\r\n\r" +
              "A description\n\r\n\r"+
              "People:\n\r" +
              "David\n\r\n\r"
      expect_event(location, observer, :show, :message => expected_description) 

      location.on_look(look_event)
    end
  end

  context "When someone say something in the location" do
    it "should dispatch what said to all the players in the location" do
      speaker = Player.new("Speaker")
      location = Location.new(1, "Title", "Description")
      talk_event = Event.new(speaker, location, :talk, :message => "Hello everyone")

      a_person = Player.new("Person 1")
      another_person = Player.new("Person 2")
      [a_person, another_person].each do |person|
        location.add_player(person)
        expect_event(location, person, :show, :message => "Speaker said: Hello everyone")
      end

      location.on_talk(talk_event)
    end
  end

  context "When someone leaves the location" do
    before :each do
      @player = Player.new("David")
      @location = Location.new(1, "title", "description")
      @destination = Location.new(2, "destination", "destination")
      @location.add_exit(Exit.new("east", @destination))
    end

    it "should remove player from current location" do
      @location.add_player(@player)
      leave_event = Event.new(@player, @location, :leave, :exit => "east")

      @location.on_leave(leave_event)

      @location.players.should be_empty
    end

    it "should send an enter event to the destination" do
      @location.add_player(@player)
      leave_event = Event.new(@player, @location, :leave, :exit => "east")

      expect_event(@player, @destination, :enter, :origin => @location)
      @location.on_leave(leave_event)
    end

    it "should notifiy other players in the location" do
      other_player = Player.new("other")
      @location.add_player(@player)
      @location.add_player(other_player)

      leave_event = Event.new(@player, @location, :leave, :exit => "east")

      expect_event(@player, @destination, :enter, :origin => @location)
      expect_event(@location, other_player, :show, :message => "David leaves east")
      @location.on_leave(leave_event)
    end
  end

  context "When entering the location" do
    before :each do
      @player = Player.new("David")
      @origin = Location.new(2, "origin", "description")
      @location = Location.new(1, "title", "description")
      @origin.add_exit(Exit.new("east", @location))
      @location.add_exit(Exit.new("west", @origin))
    end
    it "should add the player at the list of player" do
      enter_event = Event.new(@player, @location, :enter, :origin => @origin)

      @location.on_enter(enter_event)

      @location.players.should include(@player)
    end

    it "should notify other players in the location" do
      other_player = Player.new("Player that was already there")
      @location.add_player(other_player)
      enter_event = Event.new(@player, @location, :enter, :origin => @origin)

      expect_event(@location, other_player, :show, :message => "David arrives walking from west")
      expect_event(@player, @location, :look)
      @location.on_enter(enter_event)
    end

    it "should change notification when appearing magically" do
      other_player = Player.new("Player that was already there")
      @location.add_player(other_player)
      enter_event = Event.new(@player, @location, :enter, :origin => :nowhere)

      expect_event(@location, other_player, :show, :message => "David appears out of thin air")
      expect_event(@player, @location, :look)
      @location.on_enter(enter_event)
    end

    it "should show description of the room to the player" do
      enter_event = Event.new(@player, @location, :enter, :origin => @origin)
      
      expect_event(@player, @location, :look)
      @location.on_enter(enter_event)
    end
  end
end
