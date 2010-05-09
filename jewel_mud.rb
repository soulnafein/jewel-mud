require 'gserver'
require 'singleton'
require 'yaml'

Dir["lib/**/*.rb"].sort.each {|file| require file }


class JewelMud < GServer
  def starting
    Game.instance.run
  end

  def serve(socket)
    telnet_session = TelnetSession.new(socket)
    Game.instance.enter_game(telnet_session)
  end
end
