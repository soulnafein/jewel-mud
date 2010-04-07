require 'rspec'

Rspec.configure do |config|
  require 'rspec/expectations'
  config.include Rspec::Matchers
  config.mock_with :rspec
end

require 'jewel_mud'

module Build
  def self.a_player
    Player.new("David", StringIO.new)
  end
end
