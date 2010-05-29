class HumanBody
  attr_reader :head, :hands

  def initialize
    @head = BodyPart.new(:head)
    @hands = BodyPart.new(:hands)
    @body_parts = [@head, @hands]
  end

  def pick_garment(item_name)
    item = garments.find {|g| g.name == item_name }
    raise ItemNotAvailable if item.nil?
    body_part = @body_parts.find { |p| p.name == item.wearable_on }
    body_part.remove_garment
    item
  end

  def wear_garment(item)
    body_part = @body_parts.find { |p| p.name == item.wearable_on }
    body_part.garment = item
  end

  def garments
    @body_parts.map {|p| p.garment }.compact
  end

  def print_equipment
    output = "[color=yellow]You are wearing:[/color]\n"
    garments.each do |garment|
      output << "#{garment.description.capitalize} on the #{garment.wearable_on}\n"
    end
    output << "Nothing...\n" if garments.empty?
    output
  end
end