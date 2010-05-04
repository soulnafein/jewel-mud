class SayCommand
  attr_reader :message
  
  def initialize(character, event_manager, *args)
    @character, @event_manager = character, event_manager
    @message = args.first
  end

  def self.parse(input, character, event_manager)
    if input =~ /say (.*)/i
      return SayCommand.new(character, event_manager, $1)
    end
  end

  def execute
    @character.notification("You said: #{@message}")
    notification = "#{@character.name} said: #{@message}"
    @character.current_location.notify_all_characters_except(@character, notification)
  end
end