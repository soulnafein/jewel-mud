require 'jewel_mud'

server = JewelMud.new(1234)
server.audit = true
server.debug = true
server.start

server.join

puts "Server has been terminated"
