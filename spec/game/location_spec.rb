require "spec/spec_helper"

describe Location do
  before :each do
    @telnet_session = mock.as_null_object
  end

  context "When looked by someone" do
    it "should send a show event to the observer" do
      location = Location.new(1, "A title", "A description")
      location.add_exit(Exit.new("north", nil))
      location.add_exit(Exit.new("south", nil))
      location.add_exit(Exit.new("east", nil))
      location.add_character(Build.a_character)

      observer = Character.new("Observer", @telnet_session)

      look_event = Event.new(observer, location, :look)

      expected_description = "You see:\n" +
              "[color=red]A title[/color]\n" +
              "A description\n"+
              "People:\n" +
              "David\n" +
              "[color=green]You see exits leading north, south and east.[/color]\n"

      @telnet_session.should_receive(:write).with(expected_description)

      location.on_look(look_event)
    end
  end

  context "When someone look for an exit in the location" do
    context "When the exit exist" do
      it "should send the exit description to the observer" do
        location = Location.new(1, "A title", "A description")
        location.add_exit(Exit.new("west", nil, "Exit description"))
        observer = Character.new("Observer", @telnet_session)
        look_event = Event.new(observer, location, :look, :target => "west")

        @telnet_session.should_receive(:write).with("Exit description")

        location.on_look(look_event)
      end
    end

    context "When the exit does not exist" do
      it "should let the observer know" do
        location = Location.new(1, "A title", "A description")
        observer = Character.new("Observer", @telnet_session)
        look_event = Event.new(observer, location, :look, :target => "west")

        @telnet_session.should_receive(:write).with("There isn't anything called 'west' here.")

        location.on_look(look_event)



      end
    end
  end

  context "When someone say something in the location" do
    it "should dispatch what said to all the characters in the location" do
      speaker = Character.new("Speaker")
      location = Location.new(1, "Title", "Description")
      talk_event = Event.new(speaker, location, :talk, :message => "Hello everyone")

      a_person = Character.new("Person 1")
      another_person = Character.new("Person 2")
      [a_person, another_person].each do |person|
        location.add_character(person)
        expect_event(location, person, :show, :message => "Speaker said: Hello everyone")
      end

      location.on_talk(talk_event)
    end
  end

  context "When someone emote something in the location" do
    it "should dispatch the emote players in the location" do
      speaker = Character.new("Speaker")
      location = Location.new(1, "Title", "Description")
      emote_event = Event.new(speaker, location, :emote, :message => "licks her finger")

      a_person = Character.new("Person 1")
      another_person = Character.new("Person 2")
      [a_person, another_person].each do |person|
        location.add_character(person)
        expect_event(location, person, :show, :message => "Speaker licks her finger")
      end

      location.on_emote(emote_event)
    end
  end

  context "When someone leaves the location" do
    before :each do
      @character = Character.new("David")
      @location = Location.new(1, "title", "description")
      @destination = Location.new(2, "destination", "destination")
      @location.add_exit(Exit.new("east", @destination))
    end

    it "should remove character from current location" do
      @location.add_character(@character)
      leave_event = Event.new(@character, @location, :leave, :exit => "east")

      @location.on_leave(leave_event)

      @location.characters.should be_empty
    end

    it "should send an enter event to the destination" do
      @location.add_character(@character)
      leave_event = Event.new(@character, @location, :leave, :exit => "east")

      expect_event(@character, @destination, :enter, :origin => @location)
      @location.on_leave(leave_event)
    end

    it "should notify the actor if the destination does not exist" do
      @location.add_character(@character)
      leave_event = Event.new(@character, @location, :leave, :exit => "not_existing")

      expect_event(@location, @character, :show,
          :message => "You can't go in that direction.")
      @location.on_leave(leave_event)
    end

    it "should notifiy other characters in the location" do
      other_character = Character.new("other")
      @location.add_character(@character)
      @location.add_character(other_character)

      leave_event = Event.new(@character, @location, :leave, :exit => "east")

      expect_event(@character, @destination, :enter, :origin => @location)
      expect_event(@location, other_character, :show, :message => "David leaves east")
      @location.on_leave(leave_event)
    end
  end

  context "When entering the location" do
    before :each do
      @character = Character.new("David")
      @origin = Location.new(2, "origin", "description")
      @location = Location.new(1, "title", "description")
      @origin.add_exit(Exit.new("east", @location))
      @location.add_exit(Exit.new("west", @origin))
    end
    
    it "should add the character at the list of character" do
      enter_event = Event.new(@character, @location, :enter, :origin => @origin)

      @location.on_enter(enter_event)

      @location.characters.should include(@character)
    end

    it "should notify other characters in the location" do
      other_character = Character.new("Character that was already there")
      @location.add_character(other_character)
      enter_event = Event.new(@character, @location, :enter, :origin => @origin)

      expect_event(@location, other_character, :show, :message => "David arrives walking from west")
      expect_event(@character, @location, :look)
      @location.on_enter(enter_event)
    end

    it "should change notification when appearing magically" do
      other_character = Character.new("Character that was already there")
      @location.add_character(other_character)
      enter_event = Event.new(@character, @location, :enter, :origin => :nowhere)

      expect_event(@location, other_character, :show, :message => "David appears out of thin air")
      expect_event(@character, @location, :look)
      @location.on_enter(enter_event)
    end

    it "should show description of the room to the character" do
      enter_event = Event.new(@character, @location, :enter, :origin => @origin)
      
      expect_event(@character, @location, :look)
      @location.on_enter(enter_event)
    end
  end
end
