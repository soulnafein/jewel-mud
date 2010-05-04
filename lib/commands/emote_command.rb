class EmoteCommand
  attr_reader :message
  
  def initialize(character, *args)
    @character = character
    @message = args.first
  end

  def self.parse(input, character)
    if input =~ /emote (.*)/i
      return EmoteCommand.new(character, $1)
    end
  end

  def execute
    @character.notification("You emote: #{@character.name} #{@message}")
    notification = "#{@character.name} #{@message}"
    @character.current_location.notify_all_characters_except(@character, notification)
  end
end
