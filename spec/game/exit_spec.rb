require "spec/spec_helper"

describe Exit do
  context "When letting a character through" do
    before :each do
      @character = Character.new("David", stub(:session).as_null_object)
      @location = mock(:initial_location)
      @character.move_to(@location)
      @destination = mock(:destination).as_null_object
      @exit = Exit.new("east", @destination, "description", @location)
    end

    it "should notify the destination" do
      @destination.should_receive(:let_in).with(@character, @location)

      @exit.let_go(@character)
    end

    it "should move character to destination" do
      @exit.let_go(@character)

      @character.location.should == @destination
    end

    it "should tell the character to look the new location" do
      @character.should_receive(:look)

      @exit.let_go(@character)
    end
  end
end
