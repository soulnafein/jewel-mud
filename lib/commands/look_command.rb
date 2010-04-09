class LookCommand
  attr_reader :target
  
  def initialize(target=nil)
    @target = target
  end

  def self.parse(input)
    if input =~ /^look$/i
      return LookCommand.new
    end

    if input =~ /^look (.*)$/i
      return LookCommand.new($1)
    end
  end

  def execute_as(character)
    Game.instance.add_event(character,character.current_location,:look, :target => @target)
  end
end