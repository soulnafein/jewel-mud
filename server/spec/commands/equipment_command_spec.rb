require "spec/spec_helper"

describe EquipmentCommand do
  context "When executing" do
    it "should show equipment" do
      character = mock
      character.should_receive(:print_equipment)
      
      EquipmentCommand.new(character).execute
    end
  end
end