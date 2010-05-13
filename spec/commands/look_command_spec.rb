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
      @location.should_receive(:find_entity_by_name).
              with("east").and_return(exit)

      @character.should_receive(:look).
              with(exit)
      LookCommand.new(@character, "east").execute
    end

    it "should notify the character when an entity doesn't exist" do
      @location.should_receive(:find_entity_by_name).
              with("Wrong name").and_return(nil)

      @character.should_receive(:send_to_player).
              with("You can't see 'Wrong name' here")

      LookCommand.new(@character, "Wrong name").execute
    end
  end
end