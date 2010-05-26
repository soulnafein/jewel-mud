require 'spec/spec_helper'

describe Character do
  before :each do
    @session = mock.as_null_object
    @location = mock.as_null_object
    @character = Character.new("David", @session, "A description")
    @character.move_to(@location)
  end
  
  context "When emoting" do
    it "should send notification to attached session" do
      @session.should_receive(:write).with("You emote: David licks his finger")

      @character.emote("licks his finger")
    end

    it "should send message to his location" do
      @character.location.should_receive(:send_to_all_except).
              with(@character, "David licks his finger")
      @character.emote("licks his finger")
    end
  end

  context "When saying something" do
    it "should add a talk event for the room" do
      @location.should_receive(:send_to_all_except).
              with(@character, "[color=cyan]David says '[/color]Hello World![color=cyan]'[/color]" )

      @character.say("Hello World!")
    end

    it "should notify player of what he said" do
      @character.should_receive(:send_to_player).
              with("[color=cyan]You say '[/color]Hello World![color=cyan]'[/color]")
      @character.say("Hello World!")
    end
  end
end

