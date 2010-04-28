require "spec/spec_helper"

describe Character do
  it "should change current location" do
    location = Location.new(1, "Example", "Description")
    character = Build.a_character

    character.move_to(location)

    character.current_location.should == location
  end
end
