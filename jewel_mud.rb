require 'gserver'
require 'singleton'
require 'yaml'

Dir["lib/**/*.rb"].each {|file| require file }


class JewelMud < GServer
  def initialize(*args)
    super(*args)
    Game.instance.run
  end

  def serve(session)
    Game.instance.enter_game(session)
  end
end
