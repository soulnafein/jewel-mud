require "spec/spec_helper"

describe EmoteCommand do
  it "should tell the character to emote message" do
    character = mock
    message = "licks his finger"
    character.should_receive(:emote).with(message)

    EmoteCommand.new(character, message).execute
  end
end
