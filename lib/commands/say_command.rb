class SayCommand
  attr_reader :message
  
  def initialize(character, *args)
    @character = character
    @message = args.first
  end

  def self.parse(input, character)
    if input =~ /say (.*)/i
      return SayCommand.new(character, $1)
    end
  end

  def execute
    @character.notification("You said: #{@message}")
    notification = "#{@character.name} said: #{@message}"
    @character.current_location.notify_all_characters_except(@character, notification)
  end
end