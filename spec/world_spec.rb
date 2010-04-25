require "spec/spec_helper"

describe World do
  it "should add new characters" do
    world = World.new
    world.stub!(:persist_world)
    world.stub!(:load_world)
    name = "Soulnafein"
    password = "pa55w0rd"
    world.get_character_by_name_and_password(name, password).should be_nil

    character = world.create_new_character(name, nil, password)

    world.get_character_by_name_and_password(name, password).should_not be_nil
    character.name.should == name
  end
end