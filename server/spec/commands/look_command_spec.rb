require "spec/spec_helper"

describe LookCommand do
  context "When executing" do
    before :each do
      @location = mock(:location).as_null_object
      @character = Character.new("David", nil)
      @character.move_to(@location)
    end

    it "should tell the character to look" do
      exit = Exit.new("east", "description")
      @location.should_receive(:get_entity_by_name).
              with("east").and_return(exit)

      @character.should_receive(:look).
              with(exit)
      LookCommand.new(@character, "east").execute
    end

    it "should notify the character when an entity doesn't exist" do
      @location.should_receive(:get_entity_by_name).
              with("Wrong name").and_raise EntityNotAvailable

      @character.should_receive(:send_to_player).
              with("You can't see 'Wrong name' here")

      LookCommand.new(@character, "Wrong name").execute
    end

    it "should look the location when no argument passed" do
      @location.should_not_receive(:get_entity_by_name)
      @character.should_receive(:look).
              with(@location)

      LookCommand.new(@character, "").execute
    end
  end
end