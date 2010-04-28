require "spec/spec_helper"

describe EmotesHandler do
  context "When someone emote something in a location" do
    it "should dispatch the emote players in the location" do
      speaker = Character.new("Speaker")
      location = Location.new(1, "Title", "Description")
      emote_event = Event.new(speaker, location, :emote, :message => "licks her finger")

      a_person = Character.new("Person 1")
      another_person = Character.new("Person 2")
      [a_person, another_person].each do |person|
        location.add_character(person)
        person.should_receive(:notification, "Speaker licks her finger")
      end

      EmotesHandler.new.handle_emote(emote_event) 
    end
  end

end