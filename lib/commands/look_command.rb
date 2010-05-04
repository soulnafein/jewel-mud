class LookCommand
  attr_reader :target
  
  def initialize(character, target=nil)
    @character = character
    @target = target
  end

  def self.parse(input, character)
    if input =~ /^look$/i
      return LookCommand.new(character)
    end

    if input =~ /^look (.*)$/i
      return LookCommand.new(character, $1)
    end
  end

  def execute
    @character.look(@target)
  end
end