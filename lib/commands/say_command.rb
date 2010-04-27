class SayCommand
  attr_reader :args
  
  def initialize(*args)
    @args = args
    @message = args.first
  end

  def self.parse(input)
    if input =~ /say (.*)/i
      return SayCommand.new($1)
    end
  end

  def execute_as(character, event_handler)
    character.notification("You said: #{@message}")
    event_handler.add_event(Event.new(character, character.current_location, :talk, :message => @message))
  end
end