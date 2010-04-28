require "spec/spec_helper"

describe CommunicationHandler do
  context "When someone say something in a location" do
    it "should dispatch what said to all the characters in the location" do
      speaker = Character.new("Speaker")
      location = Location.new(1, "Title", "Description")
      talk_event = Event.new(speaker, location, :talk, :message => "Hello everyone")

      a_person = Character.new("Person 1")
      another_person = Character.new("Person 2")
      [a_person, another_person].each do |person|
        location.add_character(person)
        person.should_receive(:notification, "Speaker licks her finger")
      end

      CommunicationHandler.new.handle_talk(talk_event)
    end
  end
end