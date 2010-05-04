class LookCommand
  attr_reader :target
  
  def initialize(character, target=nil)
    @character = character
    @target = target
  end

  def execute
    @character.look(@target)
  end
end