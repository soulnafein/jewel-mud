require "spec/spec_helper"

describe SayCommand do
  context "When executing a command" do
    before :each do
      @character = Build.a_character
      @message = "Hello World!"
      @cmd = SayCommand.new(@character, @message)
    end

    it "should tell the character to say something" do
      @character.should_receive(:say).with(@message)
      @cmd.execute
    end
  end
end