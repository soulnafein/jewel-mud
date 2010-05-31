class HumanBody
  attr_reader :head, :shoulders, :arms, :hands, :waist, :legs, :feet

  def initialize
    @head = BodyPart.new(:head)
    @neck = BodyPart.new(:neck)
    @shoulders = BodyPart.new(:shoulders)
    @arms = BodyPart.new(:arms)
    @hands = BodyPart.new(:hands)
    @waist = BodyPart.new(:waist)
    @legs = BodyPart.new(:legs)
    @feet = BodyPart.new(:feet)
    @body_parts = [@head, @shoulders, @arms, @hands, @waist, @legs, @feet]
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
      output << "#{garment.description.capitalize} on your #{garment.wearable_on}\n"
    end
    output << "Nothing...\n" if garments.empty?
    output
  end

  def description
    output = "[color=cyan]"
    garments.each do |garment|
      output << "He's wearing #{garment.description} on his #{garment.wearable_on}. "
    end
    output << "He is completely naked!\n" if garments.empty?
    output << "[/color]"
  end
end