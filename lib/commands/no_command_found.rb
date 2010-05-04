class NoCommandFound
  def initialize(character, args)
    @character = character
  end

  def execute
    @character.notification("I beg you pardon? What are you trying to say?")
  end
end