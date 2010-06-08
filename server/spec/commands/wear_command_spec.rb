require "spec/spec_helper"

describe WearCommand do
  context "When executing" do
    it "should tell the character to wear an item" do
      character = mock
      character.should_receive(:wear).with("hat")
      
      WearCommand.new(character, "hat").execute
    end
  end
end