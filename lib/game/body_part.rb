class BodyPart
  def initialize(name)
    @name = name.to_s
    @garment = nil
    @part_occupied_message = "You have something on the #{name} already"
  end


  attr_reader :garment
  def garment=(item)
    raise BodyPartOccupied.new(@part_occupied_message) if @garment
    @garment = item
  end
end

class BodyPartOccupied < Exception
  attr_reader :message
  def initialize(message)
    @message = message
  end
end