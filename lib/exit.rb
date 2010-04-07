class Exit
  attr_reader :name, :destination
  
  def initialize(name, destination)
    @name, @destination = name, destination
  end
end