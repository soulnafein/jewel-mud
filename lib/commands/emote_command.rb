class EmoteCommand
  attr_reader :args
  
  def initialize(*args)
    @args = args
    @message = args.first
  end

  def self.parse(input)
    if input =~ /emote (.*)/i
      return EmoteCommand.new($1)
    end
  end

  def execute_as(character)
    character.notification("You emote: #{character.name} #{@message}")
    Game.instance.add_event(character, character.current_location, :emote, :message => @message)
  end
end
