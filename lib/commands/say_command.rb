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
    @event_manager.add_event(Event.new(@character, @character.current_location, :talk, :message => @message))
  end
end