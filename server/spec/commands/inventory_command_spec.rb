require "spec/spec_helper"

describe InventoryCommand do
  context "When executing" do
    it "should show inventory" do
      character = mock
      character.should_receive(:print_inventory)
      
      InventoryCommand.new(character).execute
    end
  end
end