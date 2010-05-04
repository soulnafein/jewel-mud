class SayCommand
  attr_reader :message
  
  def initialize(character, *args)
    @character = character
    @message = args.first
  end

  def execute
    @character.notification("You said: #{@message}")
    notification = "#{@character.name} said: #{@message}"
    @character.location.notify_all_characters_except(@character, notification)
  end
end