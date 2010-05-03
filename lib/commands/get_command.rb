class GetCommand
  attr_reader :item

  def initialize(character, event_manager,  *args)
    @character, @event_manager = character, event_manager
    @item = args.first
  end

  def self.parse(input, character, event_manager)
    if input =~ /^get ([^ ]+)$/i
      return GetCommand.new(character, event_manager, $1.downcase)
    end
  end

  def execute
    get_event = Event.new(@character, @character.current_location, :get, :item => @item)
    @event_manager.add_event(get_event)
  end
end