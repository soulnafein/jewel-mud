class EmoteCommand
  attr_reader :message
  
  def initialize(character, *args)
    @character = character
    @message = args.first
  end

  def execute
    @character.emote(@message)
  end
end
