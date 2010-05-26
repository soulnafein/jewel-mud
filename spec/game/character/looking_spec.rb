require "spec/spec_helper"

describe Character do
  before :each do
    @session = mock.as_null_object
    @location = mock.as_null_object
    @character = Character.new("David", @session, "A description")
    @character.move_to(@location)
  end

  context "When looking at a location" do
    it "should send location description to the session" do
      description = "A description"
      @location.should_receive(:description_for).with(@character).
              and_return(description)
      @session.should_receive(:write).with(description)
      @character.move_to(@location)

      @character.look(@location)
    end
  end

  context "When looking at an entity" do
    it "should send entity description to the session" do
      @entity = mock
      @entity.should_receive(:description_for).
              with(@character).and_return("A description")
      @session.should_receive(:write).with("A description")

      @character.look(@entity)
    end
  end
end
