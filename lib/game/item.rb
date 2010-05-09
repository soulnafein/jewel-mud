class Item
  attr_reader :name, :description
  def initialize(name, description)
    @name, @description = name, description
  end
end