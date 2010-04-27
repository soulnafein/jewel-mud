class Exit
  attr_reader :name, :destination, :description
  
  def initialize(name, destination, description="")
    @name, @destination, @description = name, destination, description
  end
end