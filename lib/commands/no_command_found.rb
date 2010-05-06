class NoCommandFound
  def initialize(character, args)
    @character = character
  end

  def execute
    @character.send_to_player("I beg you pardon? What are you trying to say?")
  end
end