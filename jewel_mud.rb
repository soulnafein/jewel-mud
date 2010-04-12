require 'gserver'
require 'singleton'
require 'yaml'

Dir["lib/**/*.rb"].each {|file| require file }


class JewelMud < GServer
  def initialize(*args)
    super(*args)
    Game.instance.run
  end

  def serve(socket)
    telnet_session = TelnetSession.new(socket)
    Game.instance.enter_game(telnet_session)
  end
end
