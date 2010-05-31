require 'rspec'

Rspec.configure do |config|
  require 'rspec/expectations'
  config.include Rspec::Matchers
  config.mock_with :rspec
end

require 'jewel_mud'

module Build
  def self.a_character
    Character.new("David", TelnetSession.new(StringIO.new))
  end
end
