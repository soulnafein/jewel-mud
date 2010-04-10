require "spec/spec_helper"

describe Exits do
  context "When looking for an exit by name" do
    it "should return the exit if exists" do
      exits = Exits.new
      expected_exit = Exit.new("west", nil, nil)
      exits.add(expected_exit)

      exit = exits.find_by_name("west")

      exit.should == expected_exit
    end

    it "should return nil otherwise" do
      exits = Exits.new

      exit = exits.find_by_name("west")

      exit.should be_nil
    end
  end

  context "When looking for an exit by destination" do
    it "should return the exit if exists" do
      exits = Exits.new
      destination = Location.new(1, "Name", "Description")
      expected_exit = Exit.new("west", destination)
      exits.add(expected_exit)


      exit = exits.find_by_destination(destination)

      exit.should == expected_exit
    end

    it "should return nil otherwise" do
      exits = Exits.new

      exit = exits.find_by_destination(Location.new(1, "Another", "Location"))

      exit.should be_nil
    end
  end

  it "should provide a comma separated list of exits names" do
    exits = Exits.new
    exits.add(Exit.new("west", nil))
    exits.add(Exit.new("east", nil))
    exits.add(Exit.new("north", nil))

    names = exits.get_list_of_names

    names.should == "west, east, north"
  end
end
