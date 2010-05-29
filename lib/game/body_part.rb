class BodyPart
  attr_reader :name
  def initialize(name)
    @name = name
    @garment = nil
    @part_occupied_message = "You have something on the #{name} already"
  end

  attr_reader :garment
  def garment=(item)
    raise BodyPartOccupied.new(@part_occupied_message) if @garment
    @garment = item
  end

  def remove_garment
    @garment = nil
  end
end

class BodyPartOccupied < Exception
  attr_reader :message
  def initialize(message)
    @message = message
  end
end