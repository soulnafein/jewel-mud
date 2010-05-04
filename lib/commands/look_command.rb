class LookCommand
  attr_reader :target
  
  def initialize(character, event_manager, target=nil)
    @character, @event_manager = character, event_manager
    @target = target
  end

  def self.parse(input, character, event_manager)
    if input =~ /^look$/i
      return LookCommand.new(character, event_manager)
    end

    if input =~ /^look (.*)$/i
      return LookCommand.new(character, event_manager, $1)
    end
  end

  def execute
    @character.look(@target)
  end
end