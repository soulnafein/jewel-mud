class Item
  attr_reader :name, :item, :description, :wearable_on
  def initialize(name, description, options={})
    @name, @description = name, description
    @wearable_on = options[:wearable_on]
  end

  def description_for(character)
    @description
  end
end