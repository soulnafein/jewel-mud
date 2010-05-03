class EmoteCommand
  attr_reader :message
  
  def initialize(character, event_manager, *args)
    @character, @event_manager = character, event_manager
    @message = args.first
  end

  def self.parse(input, character, event_manager)
    if input =~ /emote (.*)/i
      return EmoteCommand.new(character, event_manager, $1)
    end
  end

  def execute
    @character.notification("You emote: #{@character.name} #{@message}")
    notification = "#{@character.name} #{@message}"
    @character.current_location.notify_all_characters_except(@character, notification)
  end
end
