class Item
  attr_reader :name, :item, :description
  def initialize(name, description)
    @name, @description = name, description
  end

  def description_for(character)
    @description
  end
end